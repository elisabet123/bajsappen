import 'package:flutter/material.dart';

// copied (and some parts stripped) from flutter_rating_bar: ^3.0.1

class _NoRatingWidget extends StatelessWidget {
  final double size;
  final Widget child;
  final bool enableMask;
  final Color unratedColor;

  _NoRatingWidget({
    @required this.size,
    @required this.child,
    @required this.enableMask,
    @required this.unratedColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: enableMask
            ? _ColorFilter(
          color: unratedColor,
          child: child,
        )
            : child,
      ),
    );
  }
}

class _ColorFilter extends StatelessWidget {
  final Widget child;
  final Color color;

  _ColorFilter({
    @required this.child,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcATop,
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white,
          BlendMode.srcATop,
        ),
        child: child,
      ),
    );
  }
}

/// A widget to receive rating input from users.
///
/// [RatingBar] can also be used to display rating
///
class RatingBar extends StatefulWidget {
  /// {@template flutterRatingBar.itemCount}
  /// Defines total number of rating bar items.
  ///
  /// Default = 5
  /// {@endtemplate}
  final int itemCount;

  /// Defines the initial rating to be set to the rating bar.
  final double initialRating;

  /// Return current rating whenever rating is updated.
  final ValueChanged<double> onRatingUpdate;

  /// {@template flutterRatingBar.itemSize}
  /// Defines width and height of each rating item in the bar.
  ///
  /// Default = 40.0
  /// {@endtemplate}
  final double itemSize;

  /// {@template flutterRatingBar.itemPadding}
  /// The amount of space by which to inset each rating item.
  /// {@endtemplate}
  final EdgeInsets itemPadding;

  /// if set to true, will disable any gestures over the rating bar.
  ///
  /// Default = false
  final bool ignoreGestures;

  /// if set to true will disable drag to rate feature. Note: Enabling this mode will disable half rating capability.
  ///
  /// Default = false
  final bool tapOnlyMode;

  /// {@template flutterRatingBar.textDirection}
  /// The text flows from right to left if [textDirection] = TextDirection.rtl
  /// {@endtemplate}
  final TextDirection textDirection;

  /// {@template flutterRatingBar.itemBuilder}
  /// Widget for each rating bar item.
  /// {@endtemplate}
  final IndexedWidgetBuilder itemBuilder;

  /// if set to true, Rating Bar item will glow when being touched.
  ///
  /// Default = true
  final bool glow;

  /// Defines the radius of glow.
  ///
  /// Default = 2
  final double glowRadius;

  /// Defines color for glow.
  ///
  /// Default = theme's accent color
  final Color glowColor;

  /// {@template flutterRatingBar.direction}
  /// Direction of rating bar.
  ///
  /// Default = Axis.horizontal
  /// {@endtemplate}
  final Axis direction;

  /// {@template flutterRatingBar.unratedColor}
  /// Defines color for the unrated portion.
  ///
  /// Default = Colors.grey[200]
  /// {@endtemplate}
  final Color unratedColor;

  /// Sets minimum rating
  ///
  /// Default = 0
  final double minRating;

  /// Sets maximum rating
  ///
  /// Default = [itemCount]
  final double maxRating;

  RatingBar({
    this.itemCount = 5,
    this.initialRating = 0.0,
    @required this.onRatingUpdate,
    this.itemSize = 40.0,
    this.itemBuilder,
    this.itemPadding = const EdgeInsets.all(0.0),
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
    this.textDirection,
    this.glow = true,
    this.glowRadius = 2,
    this.direction = Axis.horizontal,
    this.glowColor,
    this.unratedColor,
    this.minRating = 0,
    this.maxRating,
  });

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0.0;

  //double _ratingHistory = 0.0;
  double iconRating = 0.0;
  double _minRating, _maxrating;
  bool _isRTL = false;
  ValueNotifier<bool> _glow = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _minRating = widget.minRating;
    _maxrating = widget.maxRating ?? widget.itemCount.toDouble();
    _rating = widget.initialRating;
  }

  @override
  void didUpdateWidget(RatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _rating = widget.initialRating;
    }
    _minRating = widget.minRating;
    _maxrating = widget.maxRating ?? widget.itemCount.toDouble();
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isRTL = (widget.textDirection ?? Directionality.of(context)) ==
        TextDirection.rtl;
    iconRating = 0.0;
    return Material(
      color: Colors.transparent,
      child: Wrap(
        alignment: WrapAlignment.start,
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        direction: widget.direction,
        children: List.generate(
          widget.itemCount,
              (index) => _buildRating(context, index),
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context, int index) {
    Widget ratingWidget;
    if (index >= _rating) {
      ratingWidget = _NoRatingWidget(
        size: widget.itemSize,
        child: widget.itemBuilder(context, index),
        enableMask: true,
        unratedColor: widget.unratedColor ?? Colors.grey[200],
      );
    } else if (index >= _rating - 1.0 &&
        index < _rating) {
      ratingWidget = SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: FittedBox(
          fit: BoxFit.contain,
          child: widget.itemBuilder(context, index),
        ),
      );
      iconRating += 1.0;
    } else {
      ratingWidget = _NoRatingWidget(
        size: widget.itemSize,
        child: widget.itemBuilder(context, index),
        enableMask: true,
        unratedColor: widget.unratedColor ?? Colors.grey[200],
      );
    }

    return IgnorePointer(
      ignoring: widget.ignoreGestures,
      child: GestureDetector(
        onTap: () {
          if (widget.onRatingUpdate != null) {
            widget.onRatingUpdate(index + 1.0);
            setState(() {
              _rating = index + 1.0;
            });
          }
        },
        onHorizontalDragStart: _isHorizontal ? (_) => _glow.value = true : null,
        onHorizontalDragEnd: _isHorizontal
            ? (_) {
          _glow.value = false;
          widget.onRatingUpdate(iconRating);
          iconRating = 0.0;
        }
            : null,
        onHorizontalDragUpdate: _isHorizontal
            ? (dragUpdates) => _dragOperation(dragUpdates, widget.direction)
            : null,
        onVerticalDragStart: _isHorizontal ? null : (_) => _glow.value = true,
        onVerticalDragEnd: _isHorizontal
            ? null
            : (_) {
          _glow.value = false;
          widget.onRatingUpdate(iconRating);
          iconRating = 0.0;
        },
        onVerticalDragUpdate: _isHorizontal
            ? null
            : (dragUpdates) => _dragOperation(dragUpdates, widget.direction),
        child: Padding(
          padding: widget.itemPadding,
          child: ValueListenableBuilder(
            valueListenable: _glow,
            builder: (context, glow, _) {
              if (glow && widget.glow) {
                Color glowColor =
                    widget.glowColor ?? Theme.of(context).accentColor;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withAlpha(30),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                      BoxShadow(
                        color: glowColor.withAlpha(20),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                    ],
                  ),
                  child: ratingWidget,
                );
              } else {
                return ratingWidget;
              }
            },
          ),
        ),
      ),
    );
  }

  bool get _isHorizontal => widget.direction == Axis.horizontal;

  void _dragOperation(DragUpdateDetails dragDetails, Axis direction) {
    if (!widget.tapOnlyMode) {
      RenderBox box = context.findRenderObject();
      var _pos = box.globalToLocal(dragDetails.globalPosition);
      double i;
      if (direction == Axis.horizontal) {
        i = _pos.dx / (widget.itemSize + widget.itemPadding.horizontal);
      } else {
        i = _pos.dy / (widget.itemSize + widget.itemPadding.vertical);
      }
      var currentRating = i.round().toDouble();
      if (currentRating > widget.itemCount) {
        currentRating = widget.itemCount.toDouble();
      }
      if (currentRating < 0) {
        currentRating = 0.0;
      }
      if (_isRTL && widget.direction == Axis.horizontal) {
        currentRating = widget.itemCount - currentRating;
      }
      if (widget.onRatingUpdate != null) {
        if (currentRating < _minRating) {
          _rating = _minRating;
        } else if (currentRating > _maxrating) {
          _rating = _maxrating;
        } else {
          _rating = currentRating;
        }
        setState(() {});
      }
    }
  }
}
