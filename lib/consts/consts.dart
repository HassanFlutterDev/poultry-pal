export './colors.dart';
export './images.dart';
export './strings.dart';
export './styles.dart';
export './firebase_const.dart';
export 'package:velocity_x/velocity_x.dart';
export 'package:flutter/material.dart';

ratings(List star1, List star2, List star3, List star4, List star5) {
  if (star2.length > star1.length &&
      star2.length > star3.length &&
      star2.length > star4.length &&
      star2.length > star5.length) {
    return 2.0;
  } else if (star1.length > star2.length &&
      star1.length > star3.length &&
      star1.length > star4.length &&
      star1.length > star5.length) {
    return 1.0;
  } else if (star3.length > star2.length &&
      star3.length > star1.length &&
      star3.length > star4.length &&
      star3.length > star5.length) {
    return 3.0;
  } else if (star4.length > star3.length &&
      star4.length > star1.length &&
      star4.length > star2.length &&
      star4.length > star5.length) {
    return 4.0;
  }
  if (star5.length > star3.length &&
      star5.length > star2.length &&
      star5.length > star4.length &&
      star5.length > star1.length) {
    return 5.0;
  } else {
    return 0.0;
  }
  // ignore: dead_code
  if (star1.length != 0 && star2.length != 0) {
    if (star1.length == star2.length) {
      return 1.0;
    }
  } else if (star2.length != 0 && star3.length != 0) {
    if (star2.length == star3.length) {
      return 2.0;
    }
  } else if (star3.length != 0 && star1.length != 0) {
    if (star3.length == star1.length) {
      return 3.0;
    }
  } else if (star4.length != 0 && star2.length != 0) {
    if (star4.length == star2.length) {
      return 4.0;
    } else if (star4.length != 0 && star3.length != 0) {
      if (star4.length == star3.length) {
        return 4.0;
      }
    } else if (star4.length != 0 && star1.length != 0) {
      if (star4.length == star1.length) {
        return 4.0;
      }
    } else if (star5.length != 0 && star2.length != 0) {
      if (star5.length == star2.length) {
        return 5.0;
      }
    } else if (star5.length != 0 && star4.length != 0) {
      if (star5.length == star4.length) {
        return 4.0;
      }
    } else if (star5.length != 0 && star3.length != 0) {
      if (star5.length == star3.length) {
        return 4.0;
      }
    } else if (star5.length != 0 && star1.length != 0) {
      if (star5.length == star1.length) {
        return 5.0;
      }
    }
  } else {
    return 0.0;
  }
}
