package com.pragma.music_station

import com.google.gson.annotations.SerializedName


data class PlayListSong(
    @SerializedName("name") var name: String?,
    @SerializedName("url") var url: String?
):java.io.Serializable{
    override fun toString(): String {
        return "PlayListSong(name=$name, url=$url)"
    }
}
