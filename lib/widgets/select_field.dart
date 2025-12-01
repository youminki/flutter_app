import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Generic select field with overlay, flip-up, search, and basic keyboard handling.
class SelectField<T> extends StatefulWidget {
  const SelectField({
    super.key,
    this.value,
    required this.items,
    required this.itemToString,
    this.onChanged,
    this.validator,
    this.hintText,
    this.searchable = true,
  });

  final T? value;
  final List<T> items;
  final String Function(T) itemToString;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? hintText;
  final bool searchable;

  @override
  State<SelectField<T>> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<SelectField<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final FocusNode _listFocus = FocusNode();
  Timer? _searchDebounce;
  // Limit initial items shown to avoid long list-build latency on open.
  // Show up to 100 items only (no '더보기' behavior).
  static const int _maxInitialItems = 100;
  int _displayCount = 0;
  int _highlightIndex = -1;
  List<T> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List<T>.from(widget.items);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _highlightIndex = -1;
    _searchController.clear();
  }

  void _openOverlay(FormFieldState<T> fieldState) {
    if (_overlayEntry != null) return;
    if (!mounted) return;

    final RenderBox? box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final Size fieldSize = box?.size ?? const Size(100, 48);
    final Offset fieldOffset = box?.localToGlobal(Offset.zero) ?? Offset.zero;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final Size overlaySize = overlay?.size ?? MediaQuery.of(context).size;

    // calculate available space
    final double spaceBelow = overlaySize.height - (fieldOffset.dy + fieldSize.height);
    final double spaceAbove = fieldOffset.dy;

    final bool flipUp = spaceBelow < 200 && spaceAbove > spaceBelow;

    final double raw = flipUp ? min(300.0, spaceAbove - 12) : min(300.0, spaceBelow - 12);
    final double maxHeight = raw.clamp(60.0, 300.0);

    final offset = flipUp ? Offset(0, -maxHeight - 6) : Offset(0, fieldSize.height + 6);

    // ensure we only display up to the max initial items when opening
    _displayCount = _filtered.length < _maxInitialItems ? _filtered.length : _maxInitialItems;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeOverlay,
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: offset,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxHeight,
                        minWidth: fieldSize.width,
                        maxWidth: fieldSize.width,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.searchable) _buildSearchField(),
                          Expanded(child: _buildList(fieldState)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    // request focus to search immediately to reduce perceived delay
    if (widget.searchable && mounted) {
      _searchFocus.requestFocus();
    }
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        decoration: const InputDecoration(
          isDense: true,
          hintText: '검색',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        onChanged: (s) {
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 120), () {
            if (!mounted) return;
            setState(() {
              _filtered = widget.items
                  .where((i) => widget.itemToString(i).toLowerCase().contains(s.toLowerCase()))
                  .toList();
              _highlightIndex = _filtered.isEmpty ? -1 : 0;
              _displayCount = _filtered.length < _maxInitialItems ? _filtered.length : _maxInitialItems;
            });
          });
        },
        onSubmitted: (_) {
          if (_highlightIndex >= 0 && _highlightIndex < _filtered.length) {
            final sel = _filtered[_highlightIndex];
            _selectValue(sel, null);
          }
        },
      ),
    );
  }

  Widget _buildList(FormFieldState<T> fieldState) {
    return KeyboardListener(
      focusNode: _listFocus,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.arrowDown) {
            setState(() {
              if (_highlightIndex < _filtered.length - 1) _highlightIndex++;
            });
          } else if (key == LogicalKeyboardKey.arrowUp) {
            setState(() {
              if (_highlightIndex > 0) _highlightIndex--;
            });
          } else if (key == LogicalKeyboardKey.enter) {
            if (_highlightIndex >= 0 && _highlightIndex < _filtered.length) {
              final sel = _filtered[_highlightIndex];
              _selectValue(sel, fieldState);
            }
          } else if (key == LogicalKeyboardKey.escape) {
            _removeOverlay();
          }
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _displayCount,
        itemBuilder: (context, idx) {
          final it = _filtered[idx];
          final selected =
              widget.value != null &&
              widget.itemToString(widget.value as T) == widget.itemToString(it);
          final highlighted = idx == _highlightIndex;
          return Container(
            color: highlighted ? Theme.of(context).highlightColor : null,
            child: ListTile(
              title: Text(widget.itemToString(it)),
              selected: selected,
              onTap: () => _selectValue(it, fieldState),
            ),
          );
        },
      ),
    );
  }

  void _selectValue(T value, FormFieldState<T>? fieldState) {
    fieldState?.didChange(value);
    widget.onChanged?.call(value);
    _removeOverlay();
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _listFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.value,
      validator: widget.validator,
      builder: (fieldState) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _fieldKey,
            onTap: () {
              if (_overlayEntry == null) {
                _filtered = List<T>.from(widget.items);
                _openOverlay(fieldState);
              } else {
                _removeOverlay();
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: widget.hintText ?? '선택',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                errorText: fieldState.errorText,
                suffixIcon: const Icon(Icons.expand_more),
                suffixIconConstraints: BoxConstraints.tight(Size(36, 36)),
              ),
              isEmpty: fieldState.value == null,
              child: fieldState.value == null
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.itemToString(fieldState.value as T),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
