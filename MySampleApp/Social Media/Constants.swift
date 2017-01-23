//
//  Constants.swift
//  Swap
//
//  Created by Micheal S. Bingham on 11/29/16.
//
//

import Foundation
import p2_OAuth2
import RealmSwift
import Realm


// =================== Spotify Authorization Information ============================================

let SPOTIFY_CLIENT_ID = "28bd419f843a494faaafeef48a0962e0"
let SPOTIFY_CLIENT_SECRET = "668e037a38b34d038686f40c85ed302e"
let spotify_scope = "user-follow-modify user-read-email user-read-birthdate"
let SPOTIFY_CALLBACK = "myapp://oauth/callback"
let SPOTIFY_URL = "https://accounts.spotify.com/authorize"
let SPOTIFY_TOKEN_URL = "https://accounts.spotify.com/api/token"
let SPOTIFY_USER_URL = "https://api.spotify.com/v1/me"
let SPOTIFY_FOLLOW_USER_URL = "https://api.spotify.com/v1/me/following"



let spotify_settings = [
    "client_id": SPOTIFY_CLIENT_ID,
    "client_secret": SPOTIFY_CLIENT_SECRET,
    "authorize_uri": SPOTIFY_URL,
    "token_uri": SPOTIFY_TOKEN_URL,   // code grant only
    "scope": spotify_scope,
    "redirect_uris": [SPOTIFY_CALLBACK],   // register the "myapp" scheme in Info.plist  ["toapp://oauth/callback"]
    "keychain": true,     // if you DON'T want keychain integration
    ] as OAuth2JSON


let spotify_oauth2 = OAuth2CodeGrant(settings: spotify_settings)

// =================== Spotify Authorization Information ============================================






// ===================== Instagram Authorization Information ========================================

let INSTAGRAM_CLIENT_ID = "22f7d645b33440399bfd78702c70276c"
let INSTAGRAM_CLIENT_SECRET = "dd9df538eb77479eb523dd25eb276a93"
let INSTAGRAM_CALLBACK = "https://wk8c7.app.goo.gl/5S4M"
let INSTAGRAM_AUTH_URL = "https://api.instagram.com/oauth/authorize"
let INSTAGRAM_SCOPES = "basic relationships"
//let INSTAGRAM_ACCESS_TOKEN_URI = "https://api.instagram.com/oauth/access_token"

let instagram_settings = [
    "client_id": INSTAGRAM_CLIENT_ID,
    "client_secret": INSTAGRAM_CLIENT_SECRET,
    "authorize_uri": INSTAGRAM_AUTH_URL,
    "token_uri": "https://api.instagram.com/oauth/access_token",
    "response_type": "code",
    "scope": INSTAGRAM_SCOPES,
    "redirect_uris": [INSTAGRAM_CALLBACK],   // register the "myapp" scheme in Info.plist
    "secret_in_body": true,
    "keychain": true,     // Keychain Integration
     "token_assume_unexpired": true,
    "verbose": true
    ] as OAuth2JSON

let instagram_oauth2 = OAuth2CodeGrantNoTokenType(settings: instagram_settings)



// ===================== Instagram Authorization Information ========================================




// =================== SoundCloud Authorization Information =========================================

let SoundCloud_ClientID = "5af081a8146cdd68e26c8fb1d1e1695a"
let SoundCloud_ClientSecret = "fd12ea0959b076e51336aa9d5ac0d8d8"
let SoundCloud_RedirectURI = "myapp://oauth/callback"
let SOUNDCLOUD_AUTH_URL = "https://soundcloud.com/connect"
let SOUNDCLOUD_TOKEN_URL = "https://API.soundcloud.com/oauth2/token"


let soundcloud_settings = [
    "client_id": SoundCloud_ClientID,
    "client_secret": SoundCloud_ClientSecret,
    "authorize_uri": SOUNDCLOUD_AUTH_URL,
    "token_uri": SOUNDCLOUD_TOKEN_URL,
    "response_type": "code",
    "scope": "non-expiring",
    "redirect_uris": [SoundCloud_RedirectURI],   // register the "myapp" scheme in Info.plist
    "secret_in_body": true,
    "keychain": true,     // Keychain Integration
     // "token_assume_unexpired": false,
    "verbose": true
    ] as OAuth2JSON

let soundcloud_oauth2 = OAuth2CodeGrantNoTokenType(settings: soundcloud_settings)


// =================== SoundCloud Authorization Information =========================================



// =================== Twitter Authorization Information ============================================

let TWITTER_CONSUMER_KEY = "vFuhhTMwYAZFEKJTOvLR0TbTU"
let TWITTER_CONSUMER_SECRET = "b6MvPtOOobLxvH78Dd4Kt3ytaL0WjsDw0kzeQhg4xfhE5gtvzz"
let TWITTER_REQUEST_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
let TWITTER_AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize"
let TWITTER_ACCESS_TOKEN_URL = "https://api.twitter.com/oauth/access_token"


let twitter_settings = [
    "client_id": TWITTER_CONSUMER_KEY,
    "client_secret": TWITTER_CONSUMER_SECRET,
    "authorize_uri": TWITTER_AUTHORIZE_URL,
    "token_uri": TWITTER_ACCESS_TOKEN_URL,   // code grant only
    //  "scope": ,
    "redirect_uris": ["swap://"],   // register the "myapp" scheme in Info.plist  ["toapp://oauth/callback"]
    "keychain": true,     // if you DON'T want keychain integration
    ] as OAuth2JSON


let twitter_oauth2 = OAuth2CodeGrant(settings: twitter_settings)

// =================== Twitter Authorization Information ============================================








//=================== Pinterest Authorization Information ==========================================//



let token = "https://api.pinterest.com/v1/oauth/token"

let PINTEREST_BASE = "https://api.pinterest.com/v1/"

let APP_ID = "4853178264895635722"
let APP_SECRET = "7f106048c23e63e0f00c47d8fd2ea860436458ddcdb1f50c99d9add6be5b766d"
let PIN_REDIRECT = "https://localhost"
let PINTEREST_URL = "https://api.pinterest.com/oauth"
let scopes = "read_relationships,write_relationships,read_public"
let response_type = "code"


let pinterest_oauth2 = OAuth2CodeGrantNoTokenType(settings: [
    "client_id": APP_ID,
    "client_secret": APP_SECRET,
    "authorize_uri": PINTEREST_URL,
    "token_uri": token,
    "redirect_uris": [PIN_REDIRECT],
    "scope": scopes,
    "keychain": true,
    "verbose": true,
    "secret_in_body": true
    
    ] as OAuth2JSON)





// ==================================== YouTube Authoriation Info ==================================

let GOOGLE_CLIENT_ID = "659462811328-pmh87rmc7b1jqr6dv0ahi1s75sga6vkc.apps.googleusercontent.com"
let googleURLScheme = "com.googleusercontent.apps.659462811328-pmh87rmc7b1jqr6dv0ahi1s75sga6vkc:/oauth"

var youtube_oauth2 = OAuth2CodeGrant(settings: [
    "client_id": GOOGLE_CLIENT_ID,
    "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://www.googleapis.com/oauth2/v3/token",
    "scope": "https://www.googleapis.com/auth/plus.circles.read https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/youtube",     // depends on the API you use
    "redirect_uris": [googleURLScheme],
    "keychain": true
    ])





