/*************************************************************************
    > File Name: main.cpp
    > Author: zxf
    > Mail: zhengxiaofeng333@163.com 
    > Created Time: 2017年02月22日 星期三 14时57分13秒
 ************************************************************************/

#include <iostream>
#include <unistd.h>
using namespace std;

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickView>
#include "network.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    qmlRegisterType<Network> ("com.shelly", 1, 0, "Network");


    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/main.qml"));

    app.quitOnLastWindowClosed();
    return app.exec();
}
