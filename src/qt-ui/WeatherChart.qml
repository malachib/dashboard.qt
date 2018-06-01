import QtQuick 2.0
import QtCharts 2.0

ChartView {
    property variant model

    StackedBarSeries {
        VBarModelMapper {
            model: model
        }
    }
}
