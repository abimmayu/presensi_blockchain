import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/feature/dashboard/domain/present_in_year.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class PresentChart extends StatelessWidget {
  final List<PresentinYear> data;

  const PresentChart({
    super.key,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    List<charts.Series<PresentinYear, String>> series = [
      charts.Series(
        id: "developers",
        data: data,
        domainFn: (PresentinYear series, _) => "${series.month}",
        measureFn: (PresentinYear series, _) => series.present,
        colorFn: (PresentinYear series, _) => series.barColor,
      )
    ];

    return Container(
      height: ScreenUtil().setHeight(200),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: charts.BarChart(
              series,
              animate: true,
              behaviors: [
                charts.SlidingViewport(),
                charts.PanAndZoomBehavior(),
              ],
              domainAxis: charts.OrdinalAxisSpec(
                viewport: charts.OrdinalViewport("${series.first}", 5),
              ),
            ),
          )
        ],
      ),
    );
  }
}
