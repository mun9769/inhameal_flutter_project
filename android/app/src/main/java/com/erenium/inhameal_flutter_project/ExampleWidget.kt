package com.erenium.inhameal_flutter_project

import android.annotation.SuppressLint
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject
import kotlinx.android.synthetic.main.*
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

//                val meals = widgetData.getString("meals", null)
//                val jsonObj = JSONObject(meals)
//                val mymap = jsonObj.toMap()

                setTextViewText(R.id.cafe_name, meals ?: "No title set")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        // create TextView
    }

    fun JSONObject.toMap(): Map<String, *> = keys().asSequence().associateWith {
        when (val value = this[it])
        {
            is JSONArray ->
            {
                val map = (0 until value.length()).associate { Pair(it.toString(), value[it]) }
                JSONObject(map).toMap().values.toList()
            }
            is JSONObject -> value.toMap()
            JSONObject.NULL -> null
            else            -> value
        }
    }
}