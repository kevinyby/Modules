#import <Foundation/Foundation.h>

@interface FontHelper : NSObject

+(void) listAllFontNames;

+(UIFont*) getFontFromTTFFile: (NSString*)ttfFilePath withSize:(int)fontSize ;



#pragma mark - 

+(void) setBoldToFont: (UILabel*)label;

+(void) setItalicToFont: (UILabel*)label;

@end



// listAllFontNames:
/**

 (
 Thonburi,
 "Snell Roundhand",
 "Academy Engraved LET",
 "Marker Felt",
 Avenir,
 "Geeza Pro",
 "Arial Rounded MT Bold",
 "Trebuchet MS",
 Arial,
 Marion,
 Menlo,
 "Malayalam Sangam MN",
 "Kannada Sangam MN",
 "Gurmukhi MN",
 "Bodoni 72 Oldstyle",
 "Bradley Hand",
 Cochin,
 "Sinhala Sangam MN",
 "Hiragino Kaku Gothic ProN",
 "Iowan Old Style",
 Damascus,
 "Al Nile",
 Farah,
 Papyrus,
 Verdana,
 "Zapf Dingbats",
 "DIN Condensed",
 "Avenir Next Condensed",
 Courier,
 "Hoefler Text",
 "Euphemia UCAS",
 Helvetica,
 "Hiragino Mincho ProN",
 "Bodoni Ornaments",
 Superclarendon,
 Mishafi,
 Optima,
 "Gujarati Sangam MN",
 "Devanagari Sangam MN",
 "Apple Color Emoji",
 "Savoye LET",
 Kailasa,
 "Times New Roman",
 "Telugu Sangam MN",
 "Heiti SC",
 "Apple SD Gothic Neo",
 Futura,
 "Bodoni 72",
 Baskerville,
 Symbol,
 "Heiti TC",
 Copperplate,
 "Party LET",
 "American Typewriter",
 "Chalkboard SE",
 "Avenir Next",
 "Bangla Sangam MN",
 Noteworthy,
 Zapfino,
 "Tamil Sangam MN",
 Chalkduster,
 "Arial Hebrew",
 Georgia,
 "Helvetica Neue",
 "Gill Sans",
 Palatino,
 "Courier New",
 "Oriya Sangam MN",
 Didot,
 "DIN Alternate",
 "Bodoni 72 Smallcaps"
 )
 
 
 
Thonburi : (
 "Thonburi-Bold",
 Thonburi,
 "Thonburi-Light"
 )
 
Snell Roundhand : (
 "SnellRoundhand-Black",
 "SnellRoundhand-Bold",
 SnellRoundhand
 )
 
Academy Engraved LET : (
 AcademyEngravedLetPlain
 )
 
Marker Felt : (
 "MarkerFelt-Thin",
 "MarkerFelt-Wide"
 )
 
Avenir : (
 "Avenir-Heavy",
 "Avenir-Oblique",
 "Avenir-Black",
 "Avenir-Book",
 "Avenir-BlackOblique",
 "Avenir-HeavyOblique",
 "Avenir-Light",
 "Avenir-MediumOblique",
 "Avenir-Medium",
 "Avenir-LightOblique",
 "Avenir-Roman",
 "Avenir-BookOblique"
 )
 
Geeza Pro : (
 "GeezaPro-Bold",
 GeezaPro,
 "GeezaPro-Light"
 )
 
Arial Rounded MT Bold : (
 ArialRoundedMTBold
 )
 
Trebuchet MS : (
 "Trebuchet-BoldItalic",
 TrebuchetMS,
 "TrebuchetMS-Bold",
 "TrebuchetMS-Italic"
 )
 
Arial : (
 ArialMT,
 "Arial-BoldItalicMT",
 "Arial-ItalicMT",
 "Arial-BoldMT"
 )
 
Marion : (
 "Marion-Regular",
 "Marion-Italic",
 "Marion-Bold"
 )
 
Menlo : (
 "Menlo-BoldItalic",
 "Menlo-Regular",
 "Menlo-Bold",
 "Menlo-Italic"
 )
 
Malayalam Sangam MN : (
 MalayalamSangamMN,
 "MalayalamSangamMN-Bold"
 )
 
Kannada Sangam MN : (
 KannadaSangamMN,
 "KannadaSangamMN-Bold"
 )
 
Gurmukhi MN : (
 "GurmukhiMN-Bold",
 GurmukhiMN
 )
 
Bodoni 72 Oldstyle : (
 "BodoniSvtyTwoOSITCTT-BookIt",
 "BodoniSvtyTwoOSITCTT-Bold",
 "BodoniSvtyTwoOSITCTT-Book"
 )
 
Bradley Hand : (
 "BradleyHandITCTT-Bold"
 )
 
Cochin : (
 "Cochin-Bold",
 "Cochin-BoldItalic",
 "Cochin-Italic",
 Cochin
 )
 
Sinhala Sangam MN : (
 SinhalaSangamMN,
 "SinhalaSangamMN-Bold"
 )
 
Hiragino Kaku Gothic ProN : (
 "HiraKakuProN-W6",
 "HiraKakuProN-W3"
 )
 
Iowan Old Style : (
 "IowanOldStyle-Bold",
 "IowanOldStyle-BoldItalic",
 "IowanOldStyle-Italic",
 "IowanOldStyle-Roman"
 )
 
Damascus : (
 DamascusBold,
 Damascus,
 DamascusMedium,
 DamascusSemiBold
 )
 
Al Nile : (
 "AlNile-Bold",
 AlNile
 )
 
Farah : (
 Farah
 )
 
Papyrus : (
 "Papyrus-Condensed",
 Papyrus
 )
 
Verdana : (
 "Verdana-BoldItalic",
 "Verdana-Italic",
 Verdana,
 "Verdana-Bold"
 )
 
Zapf Dingbats : (
 ZapfDingbatsITC
 )
 
DIN Condensed : (
 "DINCondensed-Bold"
 )
 
Avenir Next Condensed : (
 "AvenirNextCondensed-Regular",
 "AvenirNextCondensed-MediumItalic",
 "AvenirNextCondensed-UltraLightItalic",
 "AvenirNextCondensed-UltraLight",
 "AvenirNextCondensed-BoldItalic",
 "AvenirNextCondensed-Italic",
 "AvenirNextCondensed-Medium",
 "AvenirNextCondensed-HeavyItalic",
 "AvenirNextCondensed-Heavy",
 "AvenirNextCondensed-DemiBoldItalic",
 "AvenirNextCondensed-DemiBold",
 "AvenirNextCondensed-Bold"
 )
 
Courier : (
 Courier,
 "Courier-Oblique",
 "Courier-BoldOblique",
 "Courier-Bold"
 )
 
Hoefler Text : (
 "HoeflerText-Regular",
 "HoeflerText-BlackItalic",
 "HoeflerText-Italic",
 "HoeflerText-Black"
 )
 
Euphemia UCAS : (
 EuphemiaUCAS,
 "EuphemiaUCAS-Bold",
 "EuphemiaUCAS-Italic"
 )
 
Helvetica : (
 "Helvetica-Oblique",
 "Helvetica-Light",
 "Helvetica-Bold",
 Helvetica,
 "Helvetica-BoldOblique",
 "Helvetica-LightOblique"
 )
 
Hiragino Mincho ProN : (
 "HiraMinProN-W6",
 "HiraMinProN-W3"
 )
 
Bodoni Ornaments : (
 BodoniOrnamentsITCTT
 )
 
Superclarendon : (
 "Superclarendon-Regular",
 "Superclarendon-BoldItalic",
 "Superclarendon-Light",
 "Superclarendon-BlackItalic",
 "Superclarendon-Italic",
 "Superclarendon-LightItalic",
 "Superclarendon-Bold",
 "Superclarendon-Black"
 )
 
Mishafi : (
 DiwanMishafi
 )
 
Optima : (
 "Optima-Regular",
 "Optima-Italic",
 "Optima-Bold",
 "Optima-BoldItalic",
 "Optima-ExtraBlack"
 )
 
Gujarati Sangam MN : (
 "GujaratiSangamMN-Bold",
 GujaratiSangamMN
 )
 
Devanagari Sangam MN : (
 DevanagariSangamMN,
 "DevanagariSangamMN-Bold"
 )
 
Apple Color Emoji : (
 AppleColorEmoji
 )
 
Savoye LET : (
 SavoyeLetPlain
 )
 
Kailasa : (
 Kailasa,
 "Kailasa-Bold"
 )
 
Times New Roman : (
 "TimesNewRomanPS-BoldItalicMT",
 TimesNewRomanPSMT,
 "TimesNewRomanPS-BoldMT",
 "TimesNewRomanPS-ItalicMT"
 )
 
Telugu Sangam MN : (
 TeluguSangamMN,
 "TeluguSangamMN-Bold"
 )
 
Heiti SC : (
 "STHeitiSC-Medium",
 "STHeitiSC-Light"
 )
 
Apple SD Gothic Neo : (
 "AppleSDGothicNeo-Thin",
 "AppleSDGothicNeo-SemiBold",
 "AppleSDGothicNeo-Medium",
 "AppleSDGothicNeo-Regular",
 "AppleSDGothicNeo-Bold",
 "AppleSDGothicNeo-Light"
 )
 
Futura : (
 "Futura-Medium",
 "Futura-CondensedMedium",
 "Futura-MediumItalic",
 "Futura-CondensedExtraBold"
 )
 
Bodoni 72 : (
 "BodoniSvtyTwoITCTT-Book",
 "BodoniSvtyTwoITCTT-Bold",
 "BodoniSvtyTwoITCTT-BookIta"
 )
 
Baskerville : (
 "Baskerville-Bold",
 "Baskerville-SemiBoldItalic",
 "Baskerville-BoldItalic",
 Baskerville,
 "Baskerville-SemiBold",
 "Baskerville-Italic"
 )
 
Symbol : (
 Symbol
 )
 
Heiti TC : (
 "STHeitiTC-Medium",
 "STHeitiTC-Light"
 )
 
Copperplate : (
 Copperplate,
 "Copperplate-Light",
 "Copperplate-Bold"
 )
 
Party LET : (
 PartyLetPlain
 )
 
American Typewriter : (
 "AmericanTypewriter-Light",
 "AmericanTypewriter-CondensedLight",
 "AmericanTypewriter-CondensedBold",
 AmericanTypewriter,
 "AmericanTypewriter-Condensed",
 "AmericanTypewriter-Bold"
 )
 
Chalkboard SE : (
 "ChalkboardSE-Light",
 "ChalkboardSE-Regular",
 "ChalkboardSE-Bold"
 )
 
Avenir Next : (
 "AvenirNext-MediumItalic",
 "AvenirNext-Bold",
 "AvenirNext-UltraLight",
 "AvenirNext-DemiBold",
 "AvenirNext-HeavyItalic",
 "AvenirNext-Heavy",
 "AvenirNext-Medium",
 "AvenirNext-Italic",
 "AvenirNext-UltraLightItalic",
 "AvenirNext-BoldItalic",
 "AvenirNext-Regular",
 "AvenirNext-DemiBoldItalic"
 )
 
Bangla Sangam MN : (
 BanglaSangamMN,
 "BanglaSangamMN-Bold"
 )
 
Noteworthy : (
 "Noteworthy-Bold",
 "Noteworthy-Light"
 )
 
Zapfino : (
 Zapfino
 )
 
Tamil Sangam MN : (
 TamilSangamMN,
 "TamilSangamMN-Bold"
 )
 
Chalkduster : (
 Chalkduster
 )
 
Arial Hebrew : (
 "ArialHebrew-Bold",
 "ArialHebrew-Light",
 ArialHebrew
 )
 
Georgia : (
 "Georgia-BoldItalic",
 "Georgia-Bold",
 "Georgia-Italic",
 Georgia
 )
 
Helvetica Neue : (
 "HelveticaNeue-BoldItalic",
 "HelveticaNeue-Light",
 "HelveticaNeue-UltraLightItalic",
 "HelveticaNeue-CondensedBold",
 "HelveticaNeue-MediumItalic",
 "HelveticaNeue-Thin",
 "HelveticaNeue-Medium",
 "HelveticaNeue-ThinItalic",
 "HelveticaNeue-LightItalic",
 "HelveticaNeue-UltraLight",
 "HelveticaNeue-Bold",
 HelveticaNeue,
 "HelveticaNeue-CondensedBlack"
 )
 
Gill Sans : (
 GillSans,
 "GillSans-Italic",
 "GillSans-BoldItalic",
 "GillSans-Light",
 "GillSans-LightItalic",
 "GillSans-Bold"
 )
 
Palatino : (
 "Palatino-Roman",
 "Palatino-Italic",
 "Palatino-Bold",
 "Palatino-BoldItalic"
 )
 
Courier New : (
 CourierNewPSMT,
 "CourierNewPS-BoldMT",
 "CourierNewPS-ItalicMT",
 "CourierNewPS-BoldItalicMT"
 )
 
Oriya Sangam MN : (
 OriyaSangamMN,
 "OriyaSangamMN-Bold"
 )
 
Didot : (
 "Didot-Bold",
 "Didot-Italic",
 Didot
 )
 
DIN Alternate : (
 "DINAlternate-Bold"
 )
 
Bodoni 72 Smallcaps : (
 "BodoniSvtyTwoSCITCTT-Book"
 )
 
 
// -----------------------------
 
systemFontOfSize:
 
.HelveticaNeueInterface-M3 - 14.000000
 
.HelveticaNeueInterface-MediumP4 - 17.000000
 
.HelveticaNeueInterface-ItalicM3 - 18.000000



**/