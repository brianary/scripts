<#
.Synopsis
Returns filterable categorical information about a range of characters.
#>

#requires -version 2
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Range',Position=0)][int]$StartValue = [char]::MinValue,
[Parameter(ParameterSetName='Range',Position=1)][int]$StopValue  = [char]::MaxValue,
[Parameter(ParameterSetName='Block',Position=0,Mandatory=$true)]
[ValidateSet('ASCII','0x2xxx','BasicLatin','Latin1Supplement',
'LatinExtendedA','LatinExtendedB','IPAExtensions','SpacingModifierLetters','CombiningDiacriticalMarks',
'GreekandCoptic','Cyrillic','CyrillicSupplement','Armenian','Hebrew','Arabic','Syriac','ArabicSupplement',
'Thaana','NKo','Samaritan','Mandaic','ArabicExtendedA','Devanagari','Bengali','Gurmukhi','Gujarati','Oriya',
'Tamil','Telugu','Kannada','Malayalam','Sinhala','Thai','Lao','Tibetan','Myanmar','Georgian','HangulJamo',
'Ethiopic','EthiopicSupplement','Cherokee','UnifiedCanadianAboriginalSyllabics','Ogham','Runic','Tagalog',
'Hanunoo','Buhid','Tagbanwa','Khmer','Mongolian','UnifiedCanadianAboriginalSyllabicsExtended','Limbu','TaiLe',
'NewTaiLue','KhmerSymbols','Buginese','TaiTham','CombiningDiacriticalMarksExtended','Balinese','Sundanese',
'Batak','Lepcha','OlChiki','SundaneseSupplement','VedicExtensions','PhoneticExtensions',
'PhoneticExtensionsSupplement','CombiningDiacriticalMarksSupplement','LatinExtendedAdditional','GreekExtended',
'GeneralPunctuation','SuperscriptsandSubscripts','CurrencySymbols','CombiningDiacriticalMarksforSymbols',
'LetterlikeSymbols','NumberForms','Arrows','MathematicalOperators','MiscellaneousTechnical','ControlPictures',
'OpticalCharacterRecognition','EnclosedAlphanumerics','BoxDrawing','BlockElements','GeometricShapes',
'MiscellaneousSymbols','Dingbats','MiscellaneousMathematicalSymbolsA','SupplementalArrowsA','BraillePatterns',
'SupplementalArrowsB','MiscellaneousMathematicalSymbolsB','SupplementalMathematicalOperators',
'MiscellaneousSymbolsandArrows','Glagolitic','LatinExtendedC','Coptic','GeorgianSupplement','Tifinagh',
'EthiopicExtended','CyrillicExtendedA','SupplementalPunctuation','CJKRadicalsSupplement','KangxiRadicals',
'IdeographicDescriptionCharacters','CJKSymbolsandPunctuation','Hiragana','Katakana','Bopomofo',
'HangulCompatibilityJamo','Kanbun','BopomofoExtended','CJKStrokes','KatakanaPhoneticExtensions',
'EnclosedCJKLettersandMonths','CJKCompatibility','CJKUnifiedIdeographsExtensionA','YijingHexagramSymbols',
'CJKUnifiedIdeographs','YiSyllables','YiRadicals','Lisu','Vai','CyrillicExtendedB','Bamum','ModifierToneLetters',
'LatinExtendedD','SylotiNagri','CommonIndicNumberForms','Phagspa','Saurashtra','DevanagariExtended','KayahLi',
'Rejang','HangulJamoExtendedA','Javanese','MyanmarExtendedB','Cham','MyanmarExtendedA','TaiViet',
'MeeteiMayekExtensions','EthiopicExtendedA','LatinExtendedE','MeeteiMayek','HangulSyllables',
'HangulJamoExtendedB','HighSurrogates','HighPrivateUseSurrogates','LowSurrogates','PrivateUseArea',
'CJKCompatibilityIdeographs','AlphabeticPresentationForms','ArabicPresentationFormsA','VariationSelectors',
'VerticalForms','CombiningHalfMarks','CJKCompatibilityForms','SmallFormVariants','ArabicPresentationFormsB',
'HalfwidthandFullwidthForms','Specials')][string]$Block,
[switch]$IsControl,      [switch]$NotControl,
[switch]$IsDigit,        [switch]$NotDigit,
[switch]$IsHighSurrogate,[switch]$NotHighSurrogate,
[switch]$IsLegalUserName,[switch]$NotLegalUserName,
[switch]$IsLegalFileName,[switch]$NotLegalFileName,
[switch]$IsLetter,       [switch]$NotLetter,
[switch]$IsLetterOrDigit,[switch]$NotLetterOrDigit,
[switch]$IsLower,        [switch]$NotLower,
[switch]$IsLowSurrogate, [switch]$NotLowSurrogate,
[switch]$IsMark,         [switch]$NotMark,
[switch]$IsNumber,       [switch]$NotNumber,
[switch]$IsPunctuation,  [switch]$NotPunctuation,
[switch]$IsSeparator,    [switch]$NotSeparator,
[switch]$IsSurrogate,    [switch]$NotSurrogate,
[switch]$IsSymbol,       [switch]$NotSymbol,
[switch]$IsUpper,        [switch]$NotUpper,
[switch]$IsWhiteSpace,   [switch]$NotWhiteSpace
)
($StartValue,$StopValue) = switch($Block)
{
    ASCII {0x0000,0x007F}
    0x2xxx {0x2000,0x2FFF}
    BasicLatin {0x0000,0x007F}
    Latin1Supplement {0x0080,0x00FF}
    LatinExtendedA {0x0100,0x017F}
    LatinExtendedB {0x0180,0x024F}
    IPAExtensions {0x0250,0x02AF}
    SpacingModifierLetters {0x02B0,0x02FF}
    CombiningDiacriticalMarks {0x0300,0x036F}
    GreekandCoptic {0x0370,0x03FF}
    Cyrillic {0x0400,0x04FF}
    CyrillicSupplement {0x0500,0x052F}
    Armenian {0x0530,0x058F}
    Hebrew {0x0590,0x05FF}
    Arabic {0x0600,0x06FF}
    Syriac {0x0700,0x074F}
    ArabicSupplement {0x0750,0x077F}
    Thaana {0x0780,0x07BF}
    NKo {0x07C0,0x07FF}
    Samaritan {0x0800,0x083F}
    Mandaic {0x0840,0x085F}
    ArabicExtendedA {0x08A0,0x08FF}
    Devanagari {0x0900,0x097F}
    Bengali {0x0980,0x09FF}
    Gurmukhi {0x0A00,0x0A7F}
    Gujarati {0x0A80,0x0AFF}
    Oriya {0x0B00,0x0B7F}
    Tamil {0x0B80,0x0BFF}
    Telugu {0x0C00,0x0C7F}
    Kannada {0x0C80,0x0CFF}
    Malayalam {0x0D00,0x0D7F}
    Sinhala {0x0D80,0x0DFF}
    Thai {0x0E00,0x0E7F}
    Lao {0x0E80,0x0EFF}
    Tibetan {0x0F00,0x0FFF}
    Myanmar {0x1000,0x109F}
    Georgian {0x10A0,0x10FF}
    HangulJamo {0x1100,0x11FF}
    Ethiopic {0x1200,0x137F}
    EthiopicSupplement {0x1380,0x139F}
    Cherokee {0x13A0,0x13FF}
    UnifiedCanadianAboriginalSyllabics {0x1400,0x167F}
    Ogham {0x1680,0x169F}
    Runic {0x16A0,0x16FF}
    Tagalog {0x1700,0x171F}
    Hanunoo {0x1720,0x173F}
    Buhid {0x1740,0x175F}
    Tagbanwa {0x1760,0x177F}
    Khmer {0x1780,0x17FF}
    Mongolian {0x1800,0x18AF}
    UnifiedCanadianAboriginalSyllabicsExtended {0x18B0,0x18FF}
    Limbu {0x1900,0x194F}
    TaiLe {0x1950,0x197F}
    NewTaiLue {0x1980,0x19DF}
    KhmerSymbols {0x19E0,0x19FF}
    Buginese {0x1A00,0x1A1F}
    TaiTham {0x1A20,0x1AAF}
    CombiningDiacriticalMarksExtended {0x1AB0,0x1AFF}
    Balinese {0x1B00,0x1B7F}
    Sundanese {0x1B80,0x1BBF}
    Batak {0x1BC0,0x1BFF}
    Lepcha {0x1C00,0x1C4F}
    OlChiki {0x1C50,0x1C7F}
    SundaneseSupplement {0x1CC0,0x1CCF}
    VedicExtensions {0x1CD0,0x1CFF}
    PhoneticExtensions {0x1D00,0x1D7F}
    PhoneticExtensionsSupplement {0x1D80,0x1DBF}
    CombiningDiacriticalMarksSupplement {0x1DC0,0x1DFF}
    LatinExtendedAdditional {0x1E00,0x1EFF}
    GreekExtended {0x1F00,0x1FFF}
    GeneralPunctuation {0x2000,0x206F}
    SuperscriptsandSubscripts {0x2070,0x209F}
    CurrencySymbols {0x20A0,0x20CF}
    CombiningDiacriticalMarksforSymbols {0x20D0,0x20FF}
    LetterlikeSymbols {0x2100,0x214F}
    NumberForms {0x2150,0x218F}
    Arrows {0x2190,0x21FF}
    MathematicalOperators {0x2200,0x22FF}
    MiscellaneousTechnical {0x2300,0x23FF}
    ControlPictures {0x2400,0x243F}
    OpticalCharacterRecognition {0x2440,0x245F}
    EnclosedAlphanumerics {0x2460,0x24FF}
    BoxDrawing {0x2500,0x257F}
    BlockElements {0x2580,0x259F}
    GeometricShapes {0x25A0,0x25FF}
    MiscellaneousSymbols {0x2600,0x26FF}
    Dingbats {0x2700,0x27BF}
    MiscellaneousMathematicalSymbolsA {0x27C0,0x27EF}
    SupplementalArrowsA {0x27F0,0x27FF}
    BraillePatterns {0x2800,0x28FF}
    SupplementalArrowsB {0x2900,0x297F}
    MiscellaneousMathematicalSymbolsB {0x2980,0x29FF}
    SupplementalMathematicalOperators {0x2A00,0x2AFF}
    MiscellaneousSymbolsandArrows {0x2B00,0x2BFF}
    Glagolitic {0x2C00,0x2C5F}
    LatinExtendedC {0x2C60,0x2C7F}
    Coptic {0x2C80,0x2CFF}
    GeorgianSupplement {0x2D00,0x2D2F}
    Tifinagh {0x2D30,0x2D7F}
    EthiopicExtended {0x2D80,0x2DDF}
    CyrillicExtendedA {0x2DE0,0x2DFF}
    SupplementalPunctuation {0x2E00,0x2E7F}
    CJKRadicalsSupplement {0x2E80,0x2EFF}
    KangxiRadicals {0x2F00,0x2FDF}
    IdeographicDescriptionCharacters {0x2FF0,0x2FFF}
    CJKSymbolsandPunctuation {0x3000,0x303F}
    Hiragana {0x3040,0x309F}
    Katakana {0x30A0,0x30FF}
    Bopomofo {0x3100,0x312F}
    HangulCompatibilityJamo {0x3130,0x318F}
    Kanbun {0x3190,0x319F}
    BopomofoExtended {0x31A0,0x31BF}
    CJKStrokes {0x31C0,0x31EF}
    KatakanaPhoneticExtensions {0x31F0,0x31FF}
    EnclosedCJKLettersandMonths {0x3200,0x32FF}
    CJKCompatibility {0x3300,0x33FF}
    CJKUnifiedIdeographsExtensionA {0x3400,0x4DBF}
    YijingHexagramSymbols {0x4DC0,0x4DFF}
    CJKUnifiedIdeographs {0x4E00,0x9FFF}
    YiSyllables {0xA000,0xA48F}
    YiRadicals {0xA490,0xA4CF}
    Lisu {0xA4D0,0xA4FF}
    Vai {0xA500,0xA63F}
    CyrillicExtendedB {0xA640,0xA69F}
    Bamum {0xA6A0,0xA6FF}
    ModifierToneLetters {0xA700,0xA71F}
    LatinExtendedD {0xA720,0xA7FF}
    SylotiNagri {0xA800,0xA82F}
    CommonIndicNumberForms {0xA830,0xA83F}
    Phagspa {0xA840,0xA87F}
    Saurashtra {0xA880,0xA8DF}
    DevanagariExtended {0xA8E0,0xA8FF}
    KayahLi {0xA900,0xA92F}
    Rejang {0xA930,0xA95F}
    HangulJamoExtendedA {0xA960,0xA97F}
    Javanese {0xA980,0xA9DF}
    MyanmarExtendedB {0xA9E0,0xA9FF}
    Cham {0xAA00,0xAA5F}
    MyanmarExtendedA {0xAA60,0xAA7F}
    TaiViet {0xAA80,0xAADF}
    MeeteiMayekExtensions {0xAAE0,0xAAFF}
    EthiopicExtendedA {0xAB00,0xAB2F}
    LatinExtendedE {0xAB30,0xAB6F}
    MeeteiMayek {0xABC0,0xABFF}
    HangulSyllables {0xAC00,0xD7AF}
    HangulJamoExtendedB {0xD7B0,0xD7FF}
    HighSurrogates {0xD800,0xDB7F}
    HighPrivateUseSurrogates {0xDB80,0xDBFF}
    LowSurrogates {0xDC00,0xDFFF}
    PrivateUseArea {0xE000,0xF8FF}
    CJKCompatibilityIdeographs {0xF900,0xFAFF}
    AlphabeticPresentationForms {0xFB00,0xFB4F}
    ArabicPresentationFormsA {0xFB50,0xFDFF}
    VariationSelectors {0xFE00,0xFE0F}
    VerticalForms {0xFE10,0xFE1F}
    CombiningHalfMarks {0xFE20,0xFE2F}
    CJKCompatibilityForms {0xFE30,0xFE4F}
    SmallFormVariants {0xFE50,0xFE6F}
    ArabicPresentationFormsB {0xFE70,0xFEFF}
    HalfwidthandFullwidthForms {0xFF00,0xFFEF}
    Specials {0xFFF0,0xFFFF}
    default {[char]::MinValue,[char]::MaxValue}
}
$invalidUserNameChars = '"/\[]:;|=,+*?<>'.ToCharArray() # https://technet.microsoft.com/en-us/library/bb726984.aspx
function Get-UnicodeRangeBlock([int]$c)
{
    if($c -le 0x007F) {'BasicLatin'}
    elseif($c -le 0x00FF) {'Latin-1Supplement'}
    elseif($c -le 0x017F) {'LatinExtended-A'}
    elseif($c -le 0x024F) {'LatinExtended-B'}
    elseif($c -le 0x02AF) {'IPAExtensions'}
    elseif($c -le 0x02FF) {'SpacingModifierLetters'}
    elseif($c -le 0x036F) {'CombiningDiacriticalMarks'}
    elseif($c -le 0x03FF) {'Greek'} # or GreekandCoptic
    elseif($c -le 0x04FF) {'Cyrillic'}
    elseif($c -le 0x052F) {'CyrillicSupplement'}
    elseif($c -le 0x058F) {'Armenian'}
    elseif($c -le 0x05FF) {'Hebrew'}
    elseif($c -le 0x06FF) {'Arabic'}
    elseif($c -le 0x074F) {'Syriac'}
    elseif($c -le 0x077F) {'ArabicSupplement'} # not supported
    elseif($c -le 0x07BF) {'Thaana'}
    elseif($c -le 0x07C0) {'NKo'} # not supported
    elseif($c -le 0x083F) {'Samaritan'} # not supported
    elseif($c -le 0x085F) {'Mandaic'} # not supported
    elseif($c -le 0x089F) {'Invalid'} # not supported
    elseif($c -le 0x08FF) {'ArabicExtended-A'} # not supported
    elseif($c -le 0x097F) {'Devanagari'}
    elseif($c -le 0x09FF) {'Bengali'}
    elseif($c -le 0x0A7F) {'Gurmukhi'}
    elseif($c -le 0x0AFF) {'Gujarati'}
    elseif($c -le 0x0B7F) {'Oriya'}
    elseif($c -le 0x0BFF) {'Tamil'}
    elseif($c -le 0x0C7F) {'Telugu'}
    elseif($c -le 0x0CFF) {'Kannada'}
    elseif($c -le 0x0D7F) {'Malayalam'}
    elseif($c -le 0x0DFF) {'Sinhala'}
    elseif($c -le 0x0E7F) {'Thai'}
    elseif($c -le 0x0EFF) {'Lao'}
    elseif($c -le 0x0FFF) {'Tibetan'}
    elseif($c -le 0x109F) {'Myanmar'}
    elseif($c -le 0x10FF) {'Georgian'}
    elseif($c -le 0x11FF) {'HangulJamo'}
    elseif($c -le 0x137F) {'Ethiopic'}
    elseif($c -le 0x139F) {'EthiopicSupplement'} # not supported
    elseif($c -le 0x13FF) {'Cherokee'}
    elseif($c -le 0x167F) {'UnifiedCanadianAboriginalSyllabics'}
    elseif($c -le 0x169F) {'Ogham'}
    elseif($c -le 0x16FF) {'Runic'}
    elseif($c -le 0x171F) {'Tagalog'}
    elseif($c -le 0x173F) {'Hanunoo'}
    elseif($c -le 0x175F) {'Buhid'}
    elseif($c -le 0x177F) {'Tagbanwa'}
    elseif($c -le 0x17FF) {'Khmer'}
    elseif($c -le 0x18AF) {'Mongolian'}
    elseif($c -le 0x18FF) {'UnifiedCanadianAboriginalSyllabicsExtended'} # not supported
    elseif($c -le 0x194F) {'Limbu'}
    elseif($c -le 0x197F) {'TaiLe'}
    elseif($c -le 0x19DF) {'NewTaiLue'} # not supported
    elseif($c -le 0x19FF) {'KhmerSymbols'}
    elseif($c -le 0x1A1F) {'Buginese'} # not supported
    elseif($c -le 0x1AAF) {'TaiTham'} # not supported
    elseif($c -le 0x1AFF) {'CombiningDiacriticalMarksExtended'} # not supported
    elseif($c -le 0x1B7F) {'Balinese'} # not supported
    elseif($c -le 0x1BBF) {'Sundanese'} # not supported
    elseif($c -le 0x1BFF) {'Batak'} # not supported
    elseif($c -le 0x1C4F) {'Lepcha'} # not supported
    elseif($c -le 0x1C7F) {'OlChiki'} # not supported
    elseif($c -le 0x1CCF) {'SundaneseSupplement'} # not supported
    elseif($c -le 0x1CFF) {'VedicExtensions'} # not supported
    elseif($c -le 0x1D7F) {'PhoneticExtensions'}
    elseif($c -le 0x1DBF) {'PhoneticExtensionsSupplement'} # not supported
    elseif($c -le 0x1DFF) {'CombiningDiacriticalMarksSupplement'} # not supported
    elseif($c -le 0x1EFF) {'LatinExtendedAdditional'}
    elseif($c -le 0x1FFF) {'GreekExtended'}
    elseif($c -le 0x206F) {'GeneralPunctuation'}
    elseif($c -le 0x209F) {'SuperscriptsandSubscripts'}
    elseif($c -le 0x20CF) {'CurrencySymbols'}
    elseif($c -le 0x20FF) {'CombiningMarksforSymbols'} # or CombiningDiacriticalMarksforSymbols
    elseif($c -le 0x214F) {'LetterlikeSymbols'}
    elseif($c -le 0x218F) {'NumberForms'}
    elseif($c -le 0x21FF) {'Arrows'}
    elseif($c -le 0x22FF) {'MathematicalOperators'}
    elseif($c -le 0x23FF) {'MiscellaneousTechnical'}
    elseif($c -le 0x243F) {'ControlPictures'}
    elseif($c -le 0x245F) {'OpticalCharacterRecognition'}
    elseif($c -le 0x24FF) {'EnclosedAlphanumerics'}
    elseif($c -le 0x257F) {'BoxDrawing'}
    elseif($c -le 0x259F) {'BlockElements'}
    elseif($c -le 0x25FF) {'GeometricShapes'}
    elseif($c -le 0x26FF) {'MiscellaneousSymbols'}
    elseif($c -le 0x27BF) {'Dingbats'}
    elseif($c -le 0x27EF) {'MiscellaneousMathematicalSymbols-A'}
    elseif($c -le 0x27FF) {'SupplementalArrows-A'}
    elseif($c -le 0x28FF) {'BraillePatterns'}
    elseif($c -le 0x297F) {'SupplementalArrows-B'}
    elseif($c -le 0x29FF) {'MiscellaneousMathematicalSymbols-B'}
    elseif($c -le 0x2AFF) {'SupplementalMathematicalOperators'}
    elseif($c -le 0x2BFF) {'MiscellaneousSymbolsandArrows'}
    elseif($c -le 0x2C5F) {'Glagolitic'} # not supported
    elseif($c -le 0x2C7F) {'LatinExtended-C'} # not supported
    elseif($c -le 0x2CFF) {'Coptic'} # not supported
    elseif($c -le 0x2D2F) {'GeorgianSupplement'} # not supported
    elseif($c -le 0x2D7F) {'Tifinagh'} # not supported
    elseif($c -le 0x2DDF) {'EthiopicExtended'} # not supported
    elseif($c -le 0x2DFF) {'CyrillicExtended-A'} # not supported
    elseif($c -le 0x2E7F) {'SupplementalPunctuation'} # not supported
    elseif($c -le 0x2EFF) {'CJKRadicalsSupplement'}
    elseif($c -le 0x2FEF) {'Invalid'} # not supported
    elseif($c -le 0x2FDF) {'KangxiRadicals'}
    elseif($c -le 0x2FFF) {'IdeographicDescriptionCharacters'}
    elseif($c -le 0x303F) {'CJKSymbolsandPunctuation'}
    elseif($c -le 0x309F) {'Hiragana'}
    elseif($c -le 0x30FF) {'Katakana'}
    elseif($c -le 0x312F) {'Bopomofo'}
    elseif($c -le 0x318F) {'HangulCompatibilityJamo'}
    elseif($c -le 0x319F) {'Kanbun'}
    elseif($c -le 0x31BF) {'BopomofoExtended'}
    elseif($c -le 0x31EF) {'CJKStrokes'} # not supported
    elseif($c -le 0x31FF) {'KatakanaPhoneticExtensions'}
    elseif($c -le 0x32FF) {'EnclosedCJKLettersandMonths'}
    elseif($c -le 0x33FF) {'CJKCompatibility'}
    elseif($c -le 0x4DBF) {'CJKUnifiedIdeographsExtensionA'}
    elseif($c -le 0x4DFF) {'YijingHexagramSymbols'}
    elseif($c -le 0x9FFF) {'CJKUnifiedIdeographs'}
    elseif($c -le 0xA48F) {'YiSyllables'}
    elseif($c -le 0xA4CF) {'YiRadicals'}
    elseif($c -le 0xA4FF) {'Lisu'} # not supported
    elseif($c -le 0xA63F) {'Vai'} # not supported
    elseif($c -le 0xA69F) {'CyrillicExtended-B'} # not supported
    elseif($c -le 0xA6FF) {'Bamum'} # not supported
    elseif($c -le 0xA71F) {'ModifierToneLetters'} # not supported
    elseif($c -le 0xA7FF) {'LatinExtended-D'} # not supported
    elseif($c -le 0xA82F) {'SylotiNagri'} # not supported
    elseif($c -le 0xA83F) {'CommonIndicNumberForms'} # not supported
    elseif($c -le 0xA87F) {'Phags-pa'} # not supported
    elseif($c -le 0xA8DF) {'Saurashtra'} # not supported
    elseif($c -le 0xA8FF) {'DevanagariExtended'} # not supported
    elseif($c -le 0xA92F) {'KayahLi'} # not supported
    elseif($c -le 0xA95F) {'Rejang'} # not supported
    elseif($c -le 0xA97F) {'HangulJamoExtended-A'} # not supported
    elseif($c -le 0xA9DF) {'Javanese'} # not supported
    elseif($c -le 0xA9FF) {'MyanmarExtended-B'} # not supported
    elseif($c -le 0xAA5F) {'Cham'} # not supported
    elseif($c -le 0xAA7F) {'MyanmarExtended-A'} # not supported
    elseif($c -le 0xAADF) {'TaiViet'} # not supported
    elseif($c -le 0xAAFF) {'MeeteiMayekExtensions'} # not supported
    elseif($c -le 0xAB2F) {'EthiopicExtended-A'} # not supported
    elseif($c -le 0xAB6F) {'LatinExtended-E'} # not supported
    elseif($c -le 0xABFF) {'MeeteiMayek'} # not supported
    elseif($c -le 0xD7AF) {'HangulSyllables'}
    elseif($c -le 0xD7FF) {'HangulJamoExtended-B'} # not supported
    elseif($c -le 0xDB7F) {'HighSurrogates'}
    elseif($c -le 0xDBFF) {'HighPrivateUseSurrogates'}
    elseif($c -le 0xDFFF) {'LowSurrogates'}
    elseif($c -le 0xF8FF) {'PrivateUse'} # or PrivateUseArea
    elseif($c -le 0xFAFF) {'CJKCompatibilityIdeographs'}
    elseif($c -le 0xFB4F) {'AlphabeticPresentationForms'}
    elseif($c -le 0xFDFF) {'ArabicPresentationForms-A'}
    elseif($c -le 0xFE0F) {'VariationSelectors'}
    elseif($c -le 0xFE1F) {'VerticalForms'} # not supported
    elseif($c -le 0xFE2F) {'CombiningHalfMarks'}
    elseif($c -le 0xFE4F) {'CJKCompatibilityForms'}
    elseif($c -le 0xFE6F) {'SmallFormVariants'}
    elseif($c -le 0xFEFF) {'ArabicPresentationForms-B'}
    elseif($c -le 0xFFEF) {'HalfwidthandFullwidthForms'}
    elseif($c -le 0xFFFF) {'Specials'}
    else {'Impossible'} #TODO: Astral Plane
}
# Only some blocks are supported: https://msdn.microsoft.com/en-us/library/20bw873z.aspx#SupportedNamedBlocks
$notablock = @'
ArabicSupplement
NKo
Samaritan
Mandaic
Invalid
ArabicExtended-A
EthiopicSupplement
UnifiedCanadianAboriginalSyllabicsExtended
NewTaiLue
Buginese
TaiTham
CombiningDiacriticalMarksExtended
Balinese
Sundanese
Batak
Lepcha
OlChiki
SundaneseSupplement
VedicExtensions
PhoneticExtensionsSupplement
CombiningDiacriticalMarksSupplement
Glagolitic
LatinExtended-C
Coptic
GeorgianSupplement
Tifinagh
EthiopicExtended
CyrillicExtended-A
SupplementalPunctuation
CJKStrokes
Lisu
Vai
CyrillicExtended-B
Bamum
ModifierToneLetters
LatinExtended-D
SylotiNagri
CommonIndicNumberForms
Phags-pa
Saurashtra
DevanagariExtended
KayahLi
Rejang
HangulJamoExtended-A
Javanese
MyanmarExtended-B
Cham
MyanmarExtended-A
TaiViet
MeeteiMayekExtensions
EthiopicExtended-A
LatinExtended-E
MeeteiMayek
HangulJamoExtended-B
VerticalForms
'@ -split '\s+'
for($_ = $StartValue; $_ -le $StopValue; $_++)
{
    [char]$c = $_
    $properties = [ordered]@{
        Character       = $c
        Value           = $_
        CodePoint       = 'U+{0:X4}' -f $_
        UnicodeBlock    = ''
        UnicodeCategory = [char]::GetUnicodeCategory($c)
        MatchesBlock    = ''
        IsControl       = [char]::IsControl($c)
        IsDigit         = [char]::IsDigit($c)
        IsHighSurrogate = [char]::IsHighSurrogate($c)
        IsLegalUserName = $invalidUserNameChars -notcontains [char]$_
        IsLegalFileName = [IO.Path]::InvalidPathChars -notcontains [char]$_
        IsLetter        = [char]::IsLetter($c)
        IsLetterOrDigit = [char]::IsLetterOrDigit($c)
        IsLower         = [char]::IsLower($c)
        IsLowSurrogate  = [char]::IsLowSurrogate($c)
        IsMark          = $c -match '\p{M}'
        IsNumber        = [char]::IsNumber($c)
        IsPunctuation   = [char]::IsPunctuation($c)
        IsSeparator     = [char]::IsSeparator($c)
        IsSurrogate     = [char]::IsSurrogate($c)
        IsSymbol        = [char]::IsSymbol($c)
        IsUpper         = [char]::IsUpper($c)
        IsWhiteSpace    = [char]::IsWhiteSpace($c)
    }
    if( ($IsControl -and !$properties.IsControl) -or
        ($NotControl -and $properties.IsControl) -or
        ($IsDigit -and !$properties.IsDigit) -or
        ($NotDigit -and $properties.IsDigit) -or
        ($IsHighSurrogate -and !$properties.IsHighSurrogate) -or
        ($NotHighSurrogate -and $properties.IsHighSurrogate) -or
        ($IsLegalUserName -and !$properties.IsLegalUserName) -or
        ($NotLegalUserName -and $properties.IsLegalUserName) -or
        ($IsLegalFileName -and !$properties.IsLegalFileName) -or
        ($NotLegalFileName -and $properties.IsLegalFileName) -or
        ($IsLetter -and !$properties.IsLetter) -or
        ($NotLetter -and $properties.IsLetter) -or
        ($IsLetterOrDigit -and !$properties.IsLetterOrDigit) -or
        ($NotLetterOrDigit -and $properties.IsLetterOrDigit) -or
        ($IsLower -and !$properties.IsLower) -or
        ($NotLower -and $properties.IsLower) -or
        ($IsLowSurrogate -and !$properties.IsLowSurrogate) -or
        ($NotLowSurrogate -and $properties.IsLowSurrogate) -or
        ($IsMark -and !$properties.IsMark) -or
        ($NotMark -and $properties.IsMark) -or
        ($IsNumber -and !$properties.IsNumber) -or
        ($NotNumber -and $properties.IsNumber) -or
        ($IsPunctuation -and !$properties.IsPunctuation) -or
        ($NotPunctuation -and $properties.IsPunctuation) -or
        ($IsSeparator -and !$properties.IsSeparator) -or
        ($NotSeparator -and $properties.IsSeparator) -or
        ($IsSurrogate -and !$properties.IsSurrogate) -or
        ($NotSurrogate -and $properties.IsSurrogate) -or
        ($IsSymbol -and !$properties.IsSymbol) -or
        ($NotSymbol -and $properties.IsSymbol) -or
        ($IsUpper -and !$properties.IsUpper) -or
        ($NotUpper -and $properties.IsUpper) -or
        ($IsWhiteSpace -and !$properties.IsWhiteSpace) -or
        ($NotWhiteSpace -and $properties.IsWhiteSpace) )
        {continue}
    $b = Get-UnicodeRangeBlock $_
    $properties.UnicodeBlock = $b
    $properties.MatchesBlock = if($notablock -contains $b) {'Error'} else {$c -match "\p{Is$b}"}
    New-Object PSObject -Property $properties
}
