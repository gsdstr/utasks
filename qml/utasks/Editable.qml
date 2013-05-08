import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1

Standard {
    id: listItem

    removable: true
    backgroundIndicator: RemovableListBG {
        state: swipingState
    }

}
