import QtQuick 2.0
import QtCharts 2.0

ChartView {
    property variant model

    title: "forecast"
    legend.alignment: Qt.AlignBottom
    antialiasing: true

    StackedBarSeries {

        /*
        VBarModelMapper {
            model: model
        } */

        axisX: BarCategoryAxis {
            categories: ["hour 1", "hour 2"]
        }

        BarSet {
            label: "Precipitation"
            values: [ 0.01, 0.1 ]
        }
    }
}
