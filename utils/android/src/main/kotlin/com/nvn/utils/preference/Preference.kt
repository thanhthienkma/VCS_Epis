package com.nvn.utils.preference

import android.content.Context
import android.preference.PreferenceManager
import android.text.TextUtils

object Preference {
    /**
     * Set Int
     * @param context
     * @param key
     * @param value
     */
    fun setInt(context: Context?, key:String?, value:Int?){
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val edit = preferences.edit()
        value?.let { edit.putInt(key, it) }
        edit.apply()
    }

    /**
     * Get Int
     * @param context
     * @param key
     */
    fun getInt(context: Context?, key:String?): Int{
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        return preferences.getInt(key, 0)
    }

    /**
     * Set Double
     * @param context
     * @param key
     * @param value
     */
    fun setDouble(context: Context?, key:String?, value:Double?){
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val edit = preferences.edit()
        edit.putString(key, value.toString())
        edit.apply()
    }

    /**
     * Get Double
     * @param context
     * @param key
     */
    fun getDouble(context: Context?, key:String?): Double{
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val stringVal =  preferences.getString(key, "")
        if(TextUtils.isEmpty(stringVal)){
            return  0.0
        }
        return try {
            stringVal.toDouble()
        }catch (e: NumberFormatException){
            0.0
        }
    }

    /**
     * Set Boolean
     * @param context
     * @param key
     * @param value
     */
    fun setBoolean(context: Context?, key:String?, value:Boolean?){
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val edit = preferences.edit()
        value?.let { edit.putBoolean(key, it) }
        edit.apply()
    }

    /**
     * Get Boolean
     * @param context
     * @param key
     */
    fun getBoolean(context: Context?, key:String?): Boolean{
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        return preferences.getBoolean(key, false)
    }


    /**
     * Set String
     * @param context
     * @param key
     * @param value
     */
    fun setString(context: Context?, key:String?, value:String?){
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val edit = preferences.edit()
        edit.putString(key, value)
        edit.apply()
    }

    /**
     * Get String
     * @param context
     * @param key
     */
    fun getString(context: Context?, key:String?): String{
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        return preferences.getString(key, "")
    }

    /**
     * Remove
     * @param context
     * @param key
     */
    fun remove(context: Context?, key:String?){
        val preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val edit = preferences.edit()
        edit.remove(key)
        edit.apply()
    }
}