// Inspired from https://github.com/thangmam/smoothratingbar original
// smooth_star_rating @ https://pub.dartlang.org/packages/smooth_star_rating
import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class ModifiedSmoothStarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;

  ModifiedSmoothStarRating(
      {this.starCount = 5,
      this.rating = 0.0,
      this.onRatingChanged,
      this.color,
      this.borderColor,
      this.size,
      this.allowHalfRating = true});

  @override
  ModifiedSmoothStarRatingState createState() {
    return new ModifiedSmoothStarRatingState();
  }
}

class ModifiedSmoothStarRatingState extends State<ModifiedSmoothStarRating> {
  double selectedStars, tempRating, ratingToApply; // 3 new vars

  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    if (index >= ratingToApply) {
      icon = new Icon(
        Icons.star_border,
        color: widget.borderColor ?? Theme.of(context).primaryColor,
        size: widget.size ?? 25.0,
      );
    } else if (index > ratingToApply - (widget.allowHalfRating ? 0.5 : 1.0) &&
        index < ratingToApply) {
      icon = new Icon(
        Icons.star_half,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size ?? 25.0,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size ?? 25.0,
      );
    }

    return new GestureDetector(
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / widget.size;
        tempRating = widget.allowHalfRating ? i : i.round().toDouble();
        if (tempRating != selectedStars) {
          setState(() {});
        }
        if (tempRating > widget.starCount) {
          tempRating = widget.starCount.toDouble();
        }
        if (tempRating < 0) {
          tempRating = 0.0;
        }
        // if (this.onRatingChanged != null) onRatingChanged(tempRating);
      },
      // new
      onHorizontalDragEnd: (dragDetails) {
        selectedStars = tempRating; // new
        if (this.widget.onRatingChanged != null && selectedStars != null)
          widget.onRatingChanged(selectedStars);
      },
      onTap: () {
        selectedStars = double.parse((index + 1).toString());
        if (this.widget.onRatingChanged != null && selectedStars != null)
          widget.onRatingChanged(selectedStars);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedStars = widget.rating ?? 0.0;
    ratingToApply = tempRating ?? selectedStars;

    return new Material(
      color: Colors.transparent,
      child: new Wrap(
          alignment: WrapAlignment.start,
          children: new List.generate(
              widget.starCount, (index) => buildStar(context, index))),
    );
  }
}
