package com.nvn.utils.model

import com.google.gson.annotations.SerializedName

class Photo(){
    @SerializedName("identifier")
    var identifier:String? = null
    @SerializedName("path")
    var path:String? = null

    constructor(identifier:String?):this(){
        this.identifier = identifier
    }
    constructor(identifier:String?,
                 path:String?):this(){
        this.identifier = identifier
        this.path = path
    }
}