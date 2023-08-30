package com.erenium.inhameal_flutter_project

import android.annotation.SuppressLint
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar
import android.content.Intent
import android.os.Build
import android.app.AlarmManager
import android.app.PendingIntent


/**
 * Implementation of App Widget functionality.
 */
class ExampleWidget : AppWidgetProvider() {
    private val ACTION_SCHEDULED_UPDATE = "com.erenium.inhameal_flutter_project.SCHEDULED_UPDATE"
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

                val lunchMenu1 = widgetData.getString("lunchMenu1", null)
                setTextViewText(R.id.lunchMenu1, lunchMenu1 ?: "오늘은 쉬는날")
                val lunchMenu2 = widgetData.getString("lunchMenu2", null)
                setTextViewText(R.id.lunchMenu2, lunchMenu2 ?: "")
                val lunchMenu3 = widgetData.getString("lunchMenu3", null)
                setTextViewText(R.id.lunchMenu3, lunchMenu3 ?: "")
                val lunchMenu4 = widgetData.getString("lunchMenu4", null)
                setTextViewText(R.id.lunchMenu4, lunchMenu4 ?: "")
                val lunchMenu5 = widgetData.getString("lunchMenu5", null)
                setTextViewText(R.id.lunchMenu5, lunchMenu5 ?: "")
                val lunchMenu6 = widgetData.getString("lunchMenu6", null)
                setTextViewText(R.id.lunchMenu6, lunchMenu6 ?: "")

            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        scheduleNextUpdate(context)
        // create TextView
    }
    private fun scheduleNextUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        // Substitute AppWidget for whatever you named your AppWidgetProvider subclass
        val intent = Intent(context, AppWidgetProvider::class.java) // , AppWidget::class.java)
        intent.action = ACTION_SCHEDULED_UPDATE
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)

        // Get a calendar instance for midnight tomorrow.
        val midnight = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 1)
            set(Calendar.MILLISECOND, 0)
            add(Calendar.DAY_OF_YEAR, 1)
        }

        // For API 19 and later, set may fire the intent a little later to save battery,
        // setExact ensures the intent goes off exactly at midnight.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
            alarmManager.set(AlarmManager.RTC_WAKEUP, midnight.timeInMillis, pendingIntent)
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, midnight.timeInMillis, pendingIntent)
        }
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