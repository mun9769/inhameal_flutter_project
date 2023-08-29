package com.erenium.inhameal_flutter_project

import android.annotation.SuppressLint
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class ExampleWidget : AppWidgetProvider() {
    @SuppressLint("RemoteViewLayout")
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            // Get reference to SharedPreferences
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.example_widget).apply {

                val cafeName = widgetData.getString("cafe_name", null)
                setTextViewText(R.id.cafe_name, cafeName ?: "No title set")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}