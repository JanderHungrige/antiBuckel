package com.example.antibuckel

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class BuckelWidget : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Get data from Shared Preferences
                val isRunning = widgetData.getBoolean("is_running", false)
                val statusText = if (isRunning) "Active" else "Inactive"
                
                setTextViewText(R.id.widget_status, statusText)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
