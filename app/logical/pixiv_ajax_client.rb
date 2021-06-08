# Notes on Pixiv's AJAX API:
#
# * The user agent must be spoofed as a browser user agent, otherwise the API
#   will return an error.
# * You must authenticate by passing a PHPSESSID cookie, otherwise the API will
#   return nothing for R-18 works.
# * The PHPSESSID cookie is obtained by logging in manually and getting the
#   cookie from the devtools.
# * The /ajax/illust/$id endpoint only returns the first image for multi-image
#   works. The /ajax/illust/$id/pages API must be used to get the full list of images.
# * Ugoiras need to use the /ajax/illust/$id/ugoira_meta API to get the frame metadata.
#
# Endpoints:
#
# * https://www.pixiv.net/ajax/illust/87598468
# * https://www.pixiv.net/ajax/user/883091/illusts?ids[]=87598468
# * https://www.pixiv.net/ajax/illust/87598468/pages
# * https://www.pixiv.net/ajax/illust/74932152/ugoira_meta
#
# https://www.pixiv.net/ajax/illust/87598468
#
# => {
#   "error": false,
#   "message": "",
#   "body": {
#     "illustId": "87598468",
#     "illustTitle": "Billow",
#     "illustComment": "須田景凪さんの1st Full Album「Billow」のイラストを担当いたしました。<br />ジャケットはデザイナーさんがイラストをぐにゃっとして作ってくれました。<br /><br />クロスフェード<br />・niconico<br /><a href=\"/jump.php?https%3A%2F%2Fwww.nicovideo.jp%2Fwatch%2Fsm38153587\" target=\"_blank\">https://www.nicovideo.jp/watch/sm38153587</a><br />・youtube<br /><a href=\"/jump.php?https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DTQnwTiFXSgc\" target=\"_blank\">https://www.youtube.com/watch?v=TQnwTiFXSgc</a><br /><br />アートディレクター<br />クロスフェード制作<br />吉良進太郎",
#     "id": "87598468",
#     "title": "Billow",
#     "description": "須田景凪さんの1st Full Album「Billow」のイラストを担当いたしました。<br />ジャケットはデザイナーさんがイラストをぐにゃっとして作ってくれました。<br /><br />クロスフェード<br />・niconico<br /><a href=\"/jump.php?https%3A%2F%2Fwww.nicovideo.jp%2Fwatch%2Fsm38153587\" target=\"_blank\">https://www.nicovideo.jp/watch/sm38153587</a><br />・youtube<br /><a href=\"/jump.php?https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DTQnwTiFXSgc\" target=\"_blank\">https://www.youtube.com/watch?v=TQnwTiFXSgc</a><br /><br />アートディレクター<br />クロスフェード制作<br />吉良進太郎",
#     "illustType": 0,
#     "createDate": "2021-02-07T09:02:03+00:00",
#     "uploadDate": "2021-02-07T09:02:03+00:00",
#     "restrict": 0,
#     "xRestrict": 0,
#     "sl": 2,
#     "urls": {
#       "mini": "https://i.pximg.net/c/48x48/img-master/img/2021/02/07/18/02/03/87598468_p0_square1200.jpg",
#       "thumb": "https://i.pximg.net/c/250x250_80_a2/img-master/img/2021/02/07/18/02/03/87598468_p0_square1200.jpg",
#       "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p0_master1200.jpg",
#       "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p0_master1200.jpg",
#       "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p0.jpg"
#     },
#     "tags": {
#       "authorId": "883091",
#       "isLocked": false,
#       "tags": [
#         {
#           "tag": "オリジナル",
#           "locked": true,
#           "deletable": false,
#           "userId": "883091",
#           "romaji": "orijinaru",
#           "translation": {
#             "en": "original"
#           },
#           "userName": "アボガド6"
#         },
#         {
#           "tag": "須田景凪",
#           "locked": true,
#           "deletable": false,
#           "userId": "883091",
#           "romaji": "sudakeina",
#           "userName": "アボガド6"
#         }
#       ],
#       "writable": true
#     },
#     "alt": "original / Billow / February 7th, 2021",
#     "storableTags": [
#       "RTJMXD26Ak",
#       "bG5P5jsGQR"
#     ],
#     "userId": "883091",
#     "userName": "アボガド6",
#     "userAccount": "avogado602",
#     "userIllusts": {
#        ...
#     },
#     "likeData": false,
#     "width": 4491,
#     "height": 4435,
#     "pageCount": 16,
#     "bookmarkCount": 3843,
#     "likeCount": 3386,
#     "commentCount": 11,
#     "responseCount": 0,
#     "viewCount": 62936,
#     "isHowto": false,
#     "isOriginal": true,
#     "imageResponseOutData": [],
#     "imageResponseData": [],
#     "imageResponseCount": 0,
#     "pollData": null,
#     "seriesNavData": null,
#     "descriptionBoothId": null,
#     "descriptionYoutubeId": "TQnwTiFXSgc",
#     "comicPromotion": null,
#     "fanboxPromotion": null,
#     "contestBanners": [],
#     "isBookmarkable": true,
#     "bookmarkData": null,
#     "contestData": null,
#     "zoneConfig": {
#       ...
#     },
#     "extraData": {
#       "meta": {
#         "title": "original / Billow / February 7th, 2021 - pixiv",
#         "description": "この作品 「Billow」 は 「オリジナル」「須田景凪」 のタグがつけられた「アボガド6」さんのイラストです。 「須田景凪さんの1st Full Album「Billow」のイラストを担当いたしました。ジャケットはデザイナーさんがイラストをぐにゃっとして作ってくれました。クロ…",
#         "canonical": "https://www.pixiv.net/en/artworks/87598468",
#         "alternateLanguages": {
#           "ja": "https://www.pixiv.net/artworks/87598468",
#           "en": "https://www.pixiv.net/en/artworks/87598468"
#         },
#         "descriptionHeader": "original are the most prominent tags for this work posted on February 7th, 2021.",
#         "ogp": {
#           "description": "須田景凪さんの1st Full Album「Billow」のイラストを担当いたしました。ジャケットはデザイナーさんがイラストをぐにゃっとして作ってくれました。クロスフェード・niconicohttps",
#           "image": "https://embed.pixiv.net/decorate.php?illust_id=87598468",
#           "title": "original / Billow / February 7th, 2021 - pixiv",
#           "type": "article"
#         },
#         "twitter": {
#           "description": "須田景凪さんの1st Full Album「Billow」のイラストを担当いたしました。\r\nジャケットはデザイナーさんがイラストをぐにゃっとして作ってくれました。\r\n\r\nクロスフェード\r\n・niconico\r\nhttps://www.nicovideo.jp/watch/sm38153587\r\n・youtube\r\nhttps://www.youtube.com/watch?v=TQnwTiFXSgc\r\n\r\nアートディレクター\r\nクロスフェード制作\r\n吉良進太郎",
#           "image": "https://embed.pixiv.net/decorate.php?illust_id=87598468",
#           "title": "Billow",
#           "card": "summary_large_image"
#         }
#       }
#     },
#     "titleCaptionTranslation": {
#       "workTitle": "",
#       "workCaption": ""
#     },
#     "isUnlisted": false,
#     "request": null
#   }
# }
#
# https://www.pixiv.net/ajax/illust/87598468/pages?lang=en
#
# => {
#   "error": false,
#   "message": "",
#   "body": [
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p0_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p0_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p0_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p0.jpg"
#       },
#       "width": 4491,
#       "height": 4435
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p1_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p1_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p1_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p1.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p2_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p2_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p2_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p2.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p3_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p3_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p3_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p3.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p4_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p4_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p4_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p4.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p5_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p5_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p5_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p5.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p6_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p6_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p6_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p6.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p7_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p7_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p7_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p7.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p8_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p8_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p8_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p8.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p9_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p9_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p9_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p9.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p10_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p10_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p10_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p10.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p11_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p11_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p11_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p11.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p12_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p12_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p12_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p12.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p13_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p13_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p13_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p13.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p14_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p14_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p14_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p14.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     },
#     {
#       "urls": {
#         "thumb_mini": "https://i.pximg.net/c/128x128/img-master/img/2021/02/07/18/02/03/87598468_p15_square1200.jpg",
#         "small": "https://i.pximg.net/c/540x540_70/img-master/img/2021/02/07/18/02/03/87598468_p15_master1200.jpg",
#         "regular": "https://i.pximg.net/img-master/img/2021/02/07/18/02/03/87598468_p15_master1200.jpg",
#         "original": "https://i.pximg.net/img-original/img/2021/02/07/18/02/03/87598468_p15.jpg"
#       },
#       "width": 5000,
#       "height": 5000
#     }
#   ]
# }
#
#  https://www.pixiv.net/ajax/illust/74932152/ugoira_meta?lang=en
#
# => {
#   "error": false,
#   "message": "",
#   "body": {
#     "src": "https://i.pximg.net/img-zip-ugoira/img/2019/05/27/17/59/33/74932152_ugoira600x600.zip",
#     "originalSrc": "https://i.pximg.net/img-zip-ugoira/img/2019/05/27/17/59/33/74932152_ugoira1920x1080.zip",
#     "mime_type": "image/jpeg",
#     "frames": [
#       {
#         "file": "000000.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000001.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000002.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000003.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000004.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000005.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000006.jpg",
#         "delay": 60
#       },
#       {
#         "file": "000007.jpg",
#         "delay": 60
#       }
#     ]
#   }
# }

class PixivAjaxClient
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36"

  attr_reader :phpsessid, :http

  def initialize(phpsessid, http: Danbooru::Http.new)
    @phpsessid = phpsessid
    @http = http
  end

  def illust(illust_id)
    get("https://www.pixiv.net/ajax/illust/#{illust_id}").with_indifferent_access
  end

  def pages(illust_id)
    get("https://www.pixiv.net/ajax/illust/#{illust_id}/pages")
  end

  def ugoira_meta(illust_id)
    get("https://www.pixiv.net/ajax/illust/#{illust_id}/ugoira_meta").with_indifferent_access
  end

  def get(url)
    response = client.cache(1.minute).get(url)

    if response.code == 200
      response.parse["body"]
    else
      DanbooruLogger.info("Pixiv API call failed (url=#{url} status=#{response.code} body=#{response.body})")
      {}
    end
  end

  def client
    @client ||= http.headers("User-Agent": USER_AGENT).cookies(PHPSESSID: phpsessid)
  end
end
