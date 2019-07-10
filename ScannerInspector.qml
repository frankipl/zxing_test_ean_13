import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import com.github.swex.QZXingNu 1.0


Rectangle {
    id: scannerInspector
    property string decoded_text:"Here goes decoded text"
    signal scannerDecoded(var value)
    color:"white"

    width: parent.width
    height: parent.height
    radius: 10

    Rectangle {
        id : cameraUI
        anchors.top:parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomRect.top
        color: "black"
        state: "PhotoCapture"

        states: [
            State {
                name: "IdleState"
                StateChangeScript {
                    script: {
                        camera.stop()
                    }
                }
            },

            State {
                name: "PhotoCapture"
                StateChangeScript {
                    script: {
                        camera.captureMode = Camera.CaptureStillImage
                        camera.start()
                    }
                }
            }
        ]

        Camera {
            id: camera
            captureMode: Camera.CaptureStillImage
            cameraState: Camera.LoadedState

            imageCapture {
                onImageCaptured: {
                    console.log("onImageCaptured")
                    imageToDecode.source=preview
                    decoder.decodeImageQML(imageToDecode)
                   // photoPreview.source = preview  // Show the preview in an Image
                }
            }
        }

        VideoOutput {
            id: viewfinder
            visible: cameraUI.state == "PhotoCapture" || cameraUI.state == "VideoCapture"

            x: 0
            y: 0
            width: parent.width - stillControls.buttonsPanelWidth
            height: parent.height

            source: camera
            autoOrientation: true
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    camera.imageCapture.capture()
                }
            }

            filters: [ filter ]
        }

        PhotoCaptureControls {
            z:10
            id: stillControls
            anchors.fill: parent
            camera: camera
            visible: cameraUI.state == "PhotoCapture"
            onPreviewSelected: cameraUI.state = "PhotoPreview"
            onVideoModeSelected: cameraUI.state = "VideoCapture"
        }
        QZXingNuFilter {
            id: filter
            onTagFound: {
                console.log("--!!--");
                console.log(tag);
                scannerDecoded(tag);
                decoded_text=tag
//                tagsFound++
//                lastTag = tag
            }
            qzxingNu: QZXingNu {
                formats: [QZXingNu.EAN_13, QZXingNu.QR_CODE]
                onDecodeResultChanged: {
                    console.log("scanner: "+decodeResult)
                }
            }
        }
    }
    Rectangle {
        id:bottomRect
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height:parent.height*0.2
        Text {
            id:resultText
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: height*0.5
            minimumPixelSize: 1
            fontSizeMode: Text.Fit
            text:scannerInspector.decoded_text
        }
    }
}


