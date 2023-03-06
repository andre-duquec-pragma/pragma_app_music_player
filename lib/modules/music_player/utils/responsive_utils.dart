class ResponsiveUtils {
  static double calculateHeightAspectRatioBasedOn({required double width}) {
    double aspectRatio = 16/9;
    return width / aspectRatio;
  }
}