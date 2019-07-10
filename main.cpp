#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QZXingNu>
#include <QZXingNuFilter>

static void registerQZXingNu()
{
    qRegisterMetaType<QZXingNu::QZXingNuDecodeResult>("QZXingNuDecodeResult");
    qRegisterMetaType<QZXingNu::DecodeStatus>("DecodeStatus");
    qRegisterMetaType<QZXingNu::BarcodeFormat>("BarcodeFormat");
    qRegisterMetaType<QZXingNu::QZXingNuDecodeResult>("QZXingNuDecodeResult");
    qmlRegisterUncreatableMetaObject(QZXingNu::staticMetaObject, "com.github.swex.QZXingNu", 1, 0,
                                     "QZXingNu", "Error: only enums allowed");
    qmlRegisterType<QZXingNu::QZXingNuFilter>("com.github.swex.QZXingNu", 1, 0, "QZXingNuFilter");
    qmlRegisterType<QZXingNu::QZXingNu>("com.github.swex.QZXingNu", 1, 0, "QZXingNu");
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    registerQZXingNu();

    engine.load(url);

    return app.exec();
}
