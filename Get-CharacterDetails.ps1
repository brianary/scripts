<#
.Synopsis
Returns filterable categorical information about a range of characters.
#>

#requires -version 2
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Range',Position=0)][int]$StartValue = [char]::MinValue,
[Parameter(ParameterSetName='Range',Position=1)][int]$StopValue  = [char]::MaxValue,
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
[switch]$IsWhiteSpace,   [switch]$NotWhiteSpace,
[Parameter(ParameterSetName='ASCII',Mandatory=$true)][switch]$IsASCII,
[Parameter(ParameterSetName='BasicLatin')][switch]$IsBasicLatin,
[Parameter(ParameterSetName='Latin1Supplement')][switch]$IsLatin1Supplement,
[Parameter(ParameterSetName='LatinExtendedA')][switch]$IsLatinExtendedA,
[Parameter(ParameterSetName='LatinExtendedB')][switch]$IsLatinExtendedB,
[Parameter(ParameterSetName='IPAExtensions')][switch]$IsIPAExtensions,
[Parameter(ParameterSetName='SpacingModifierLetters')][switch]$IsSpacingModifierLetters,
[Parameter(ParameterSetName='CombiningDiacriticalMarks')][switch]$IsCombiningDiacriticalMarks,
[Parameter(ParameterSetName='GreekandCoptic')][switch]$IsGreekandCoptic,
[Parameter(ParameterSetName='Cyrillic')][switch]$IsCyrillic,
[Parameter(ParameterSetName='CyrillicSupplement')][switch]$IsCyrillicSupplement,
[Parameter(ParameterSetName='Armenian')][switch]$IsArmenian,
[Parameter(ParameterSetName='Hebrew')][switch]$IsHebrew,
[Parameter(ParameterSetName='Arabic')][switch]$IsArabic,
[Parameter(ParameterSetName='Syriac')][switch]$IsSyriac,
[Parameter(ParameterSetName='ArabicSupplement')][switch]$IsArabicSupplement,
[Parameter(ParameterSetName='Thaana')][switch]$IsThaana,
[Parameter(ParameterSetName='NKo')][switch]$IsNKo,
[Parameter(ParameterSetName='Samaritan')][switch]$IsSamaritan,
[Parameter(ParameterSetName='Mandaic')][switch]$IsMandaic,
[Parameter(ParameterSetName='ArabicExtendedA')][switch]$IsArabicExtendedA,
[Parameter(ParameterSetName='Devanagari')][switch]$IsDevanagari,
[Parameter(ParameterSetName='Bengali')][switch]$IsBengali,
[Parameter(ParameterSetName='Gurmukhi')][switch]$IsGurmukhi,
[Parameter(ParameterSetName='Gujarati')][switch]$IsGujarati,
[Parameter(ParameterSetName='Oriya')][switch]$IsOriya,
[Parameter(ParameterSetName='Tamil')][switch]$IsTamil,
[Parameter(ParameterSetName='Telugu')][switch]$IsTelugu,
[Parameter(ParameterSetName='Kannada')][switch]$IsKannada,
[Parameter(ParameterSetName='Malayalam')][switch]$IsMalayalam,
[Parameter(ParameterSetName='Sinhala')][switch]$IsSinhala,
[Parameter(ParameterSetName='Thai')][switch]$IsThai,
[Parameter(ParameterSetName='Lao')][switch]$IsLao,
[Parameter(ParameterSetName='Tibetan')][switch]$IsTibetan,
[Parameter(ParameterSetName='Myanmar')][switch]$IsMyanmar,
[Parameter(ParameterSetName='Georgian')][switch]$IsGeorgian,
[Parameter(ParameterSetName='HangulJamo')][switch]$IsHangulJamo,
[Parameter(ParameterSetName='Ethiopic')][switch]$IsEthiopic,
[Parameter(ParameterSetName='EthiopicSupplement')][switch]$IsEthiopicSupplement,
[Parameter(ParameterSetName='Cherokee')][switch]$IsCherokee,
[Parameter(ParameterSetName='UnifiedCanadianAboriginalSyllabics')][switch]$IsUnifiedCanadianAboriginalSyllabics,
[Parameter(ParameterSetName='Ogham')][switch]$IsOgham,
[Parameter(ParameterSetName='Runic')][switch]$IsRunic,
[Parameter(ParameterSetName='Tagalog')][switch]$IsTagalog,
[Parameter(ParameterSetName='Hanunoo')][switch]$IsHanunoo,
[Parameter(ParameterSetName='Buhid')][switch]$IsBuhid,
[Parameter(ParameterSetName='Tagbanwa')][switch]$IsTagbanwa,
[Parameter(ParameterSetName='Khmer')][switch]$IsKhmer,
[Parameter(ParameterSetName='Mongolian')][switch]$IsMongolian,
[Parameter(ParameterSetName='UnifiedCanadianAboriginalSyllabicsExtended')][switch]$IsUnifiedCanadianAboriginalSyllabicsExtended,
[Parameter(ParameterSetName='Limbu')][switch]$IsLimbu,
[Parameter(ParameterSetName='TaiLe')][switch]$IsTaiLe,
[Parameter(ParameterSetName='NewTaiLue')][switch]$IsNewTaiLue,
[Parameter(ParameterSetName='KhmerSymbols')][switch]$IsKhmerSymbols,
[Parameter(ParameterSetName='Buginese')][switch]$IsBuginese,
[Parameter(ParameterSetName='TaiTham')][switch]$IsTaiTham,
[Parameter(ParameterSetName='CombiningDiacriticalMarksExtended')][switch]$IsCombiningDiacriticalMarksExtended,
[Parameter(ParameterSetName='Balinese')][switch]$IsBalinese,
[Parameter(ParameterSetName='Sundanese')][switch]$IsSundanese,
[Parameter(ParameterSetName='Batak')][switch]$IsBatak,
[Parameter(ParameterSetName='Lepcha')][switch]$IsLepcha,
[Parameter(ParameterSetName='OlChiki')][switch]$IsOlChiki,
[Parameter(ParameterSetName='SundaneseSupplement')][switch]$IsSundaneseSupplement,
[Parameter(ParameterSetName='VedicExtensions')][switch]$IsVedicExtensions,
[Parameter(ParameterSetName='PhoneticExtensions')][switch]$IsPhoneticExtensions,
[Parameter(ParameterSetName='PhoneticExtensionsSupplement')][switch]$IsPhoneticExtensionsSupplement,
[Parameter(ParameterSetName='CombiningDiacriticalMarksSupplement')][switch]$IsCombiningDiacriticalMarksSupplement,
[Parameter(ParameterSetName='LatinExtendedAdditional')][switch]$IsLatinExtendedAdditional,
[Parameter(ParameterSetName='GreekExtended')][switch]$IsGreekExtended,
[Parameter(ParameterSetName='GeneralPunctuation')][switch]$IsGeneralPunctuation,
[Parameter(ParameterSetName='SuperscriptsandSubscripts')][switch]$IsSuperscriptsandSubscripts,
[Parameter(ParameterSetName='CurrencySymbols')][switch]$IsCurrencySymbols,
[Parameter(ParameterSetName='CombiningDiacriticalMarksforSymbols')][switch]$IsCombiningDiacriticalMarksforSymbols,
[Parameter(ParameterSetName='LetterlikeSymbols')][switch]$IsLetterlikeSymbols,
[Parameter(ParameterSetName='NumberForms')][switch]$IsNumberForms,
[Parameter(ParameterSetName='Arrows')][switch]$IsArrows,
[Parameter(ParameterSetName='MathematicalOperators')][switch]$IsMathematicalOperators,
[Parameter(ParameterSetName='MiscellaneousTechnical')][switch]$IsMiscellaneousTechnical,
[Parameter(ParameterSetName='ControlPictures')][switch]$IsControlPictures,
[Parameter(ParameterSetName='OpticalCharacterRecognition')][switch]$IsOpticalCharacterRecognition,
[Parameter(ParameterSetName='EnclosedAlphanumerics')][switch]$IsEnclosedAlphanumerics,
[Parameter(ParameterSetName='BoxDrawing')][switch]$IsBoxDrawing,
[Parameter(ParameterSetName='BlockElements')][switch]$IsBlockElements,
[Parameter(ParameterSetName='GeometricShapes')][switch]$IsGeometricShapes,
[Parameter(ParameterSetName='MiscellaneousSymbols')][switch]$IsMiscellaneousSymbols,
[Parameter(ParameterSetName='Dingbats')][switch]$IsDingbats,
[Parameter(ParameterSetName='MiscellaneousMathematicalSymbolsA')][switch]$IsMiscellaneousMathematicalSymbolsA,
[Parameter(ParameterSetName='SupplementalArrowsA')][switch]$IsSupplementalArrowsA,
[Parameter(ParameterSetName='BraillePatterns')][switch]$IsBraillePatterns,
[Parameter(ParameterSetName='SupplementalArrowsB')][switch]$IsSupplementalArrowsB,
[Parameter(ParameterSetName='MiscellaneousMathematicalSymbolsB')][switch]$IsMiscellaneousMathematicalSymbolsB,
[Parameter(ParameterSetName='SupplementalMathematicalOperators')][switch]$IsSupplementalMathematicalOperators,
[Parameter(ParameterSetName='MiscellaneousSymbolsandArrows')][switch]$IsMiscellaneousSymbolsandArrows,
[Parameter(ParameterSetName='Glagolitic')][switch]$IsGlagolitic,
[Parameter(ParameterSetName='LatinExtendedC')][switch]$IsLatinExtendedC,
[Parameter(ParameterSetName='Coptic')][switch]$IsCoptic,
[Parameter(ParameterSetName='GeorgianSupplement')][switch]$IsGeorgianSupplement,
[Parameter(ParameterSetName='Tifinagh')][switch]$IsTifinagh,
[Parameter(ParameterSetName='EthiopicExtended')][switch]$IsEthiopicExtended,
[Parameter(ParameterSetName='CyrillicExtendedA')][switch]$IsCyrillicExtendedA,
[Parameter(ParameterSetName='SupplementalPunctuation')][switch]$IsSupplementalPunctuation,
[Parameter(ParameterSetName='CJKRadicalsSupplement')][switch]$IsCJKRadicalsSupplement,
[Parameter(ParameterSetName='KangxiRadicals')][switch]$IsKangxiRadicals,
[Parameter(ParameterSetName='IdeographicDescriptionCharacters')][switch]$IsIdeographicDescriptionCharacters,
[Parameter(ParameterSetName='CJKSymbolsandPunctuation')][switch]$IsCJKSymbolsandPunctuation,
[Parameter(ParameterSetName='Hiragana')][switch]$IsHiragana,
[Parameter(ParameterSetName='Katakana')][switch]$IsKatakana,
[Parameter(ParameterSetName='Bopomofo')][switch]$IsBopomofo,
[Parameter(ParameterSetName='HangulCompatibilityJamo')][switch]$IsHangulCompatibilityJamo,
[Parameter(ParameterSetName='Kanbun')][switch]$IsKanbun,
[Parameter(ParameterSetName='BopomofoExtended')][switch]$IsBopomofoExtended,
[Parameter(ParameterSetName='CJKStrokes')][switch]$IsCJKStrokes,
[Parameter(ParameterSetName='KatakanaPhoneticExtensions')][switch]$IsKatakanaPhoneticExtensions,
[Parameter(ParameterSetName='EnclosedCJKLettersandMonths')][switch]$IsEnclosedCJKLettersandMonths,
[Parameter(ParameterSetName='CJKCompatibility')][switch]$IsCJKCompatibility,
[Parameter(ParameterSetName='CJKUnifiedIdeographsExtensionA')][switch]$IsCJKUnifiedIdeographsExtensionA,
[Parameter(ParameterSetName='YijingHexagramSymbols')][switch]$IsYijingHexagramSymbols,
[Parameter(ParameterSetName='CJKUnifiedIdeographs')][switch]$IsCJKUnifiedIdeographs,
[Parameter(ParameterSetName='YiSyllables')][switch]$IsYiSyllables,
[Parameter(ParameterSetName='YiRadicals')][switch]$IsYiRadicals,
[Parameter(ParameterSetName='Lisu')][switch]$IsLisu,
[Parameter(ParameterSetName='Vai')][switch]$IsVai,
[Parameter(ParameterSetName='CyrillicExtendedB')][switch]$IsCyrillicExtendedB,
[Parameter(ParameterSetName='Bamum')][switch]$IsBamum,
[Parameter(ParameterSetName='ModifierToneLetters')][switch]$IsModifierToneLetters,
[Parameter(ParameterSetName='LatinExtendedD')][switch]$IsLatinExtendedD,
[Parameter(ParameterSetName='SylotiNagri')][switch]$IsSylotiNagri,
[Parameter(ParameterSetName='CommonIndicNumberForms')][switch]$IsCommonIndicNumberForms,
[Parameter(ParameterSetName='Phagspa')][switch]$IsPhagspa,
[Parameter(ParameterSetName='Saurashtra')][switch]$IsSaurashtra,
[Parameter(ParameterSetName='DevanagariExtended')][switch]$IsDevanagariExtended,
[Parameter(ParameterSetName='KayahLi')][switch]$IsKayahLi,
[Parameter(ParameterSetName='Rejang')][switch]$IsRejang,
[Parameter(ParameterSetName='HangulJamoExtendedA')][switch]$IsHangulJamoExtendedA,
[Parameter(ParameterSetName='Javanese')][switch]$IsJavanese,
[Parameter(ParameterSetName='MyanmarExtendedB')][switch]$IsMyanmarExtendedB,
[Parameter(ParameterSetName='Cham')][switch]$IsCham,
[Parameter(ParameterSetName='MyanmarExtendedA')][switch]$IsMyanmarExtendedA,
[Parameter(ParameterSetName='TaiViet')][switch]$IsTaiViet,
[Parameter(ParameterSetName='MeeteiMayekExtensions')][switch]$IsMeeteiMayekExtensions,
[Parameter(ParameterSetName='EthiopicExtendedA')][switch]$IsEthiopicExtendedA,
[Parameter(ParameterSetName='LatinExtendedE')][switch]$IsLatinExtendedE,
[Parameter(ParameterSetName='MeeteiMayek')][switch]$IsMeeteiMayek,
[Parameter(ParameterSetName='HangulSyllables')][switch]$IsHangulSyllables,
[Parameter(ParameterSetName='HangulJamoExtendedB')][switch]$IsHangulJamoExtendedB,
[Parameter(ParameterSetName='HighSurrogates')][switch]$IsHighSurrogates,
[Parameter(ParameterSetName='HighPrivateUseSurrogates')][switch]$IsHighPrivateUseSurrogates,
[Parameter(ParameterSetName='LowSurrogates')][switch]$IsLowSurrogates,
[Parameter(ParameterSetName='PrivateUseArea')][switch]$IsPrivateUseArea,
[Parameter(ParameterSetName='CJKCompatibilityIdeographs')][switch]$IsCJKCompatibilityIdeographs,
[Parameter(ParameterSetName='AlphabeticPresentationForms')][switch]$IsAlphabeticPresentationForms,
[Parameter(ParameterSetName='ArabicPresentationFormsA')][switch]$IsArabicPresentationFormsA,
[Parameter(ParameterSetName='VariationSelectors')][switch]$IsVariationSelectors,
[Parameter(ParameterSetName='VerticalForms')][switch]$IsVerticalForms,
[Parameter(ParameterSetName='CombiningHalfMarks')][switch]$IsCombiningHalfMarks,
[Parameter(ParameterSetName='CJKCompatibilityForms')][switch]$IsCJKCompatibilityForms,
[Parameter(ParameterSetName='SmallFormVariants')][switch]$IsSmallFormVariants,
[Parameter(ParameterSetName='ArabicPresentationFormsB')][switch]$IsArabicPresentationFormsB,
[Parameter(ParameterSetName='HalfwidthandFullwidthForms')][switch]$IsHalfwidthandFullwidthForms,
[Parameter(ParameterSetName='Specials')][switch]$IsSpecials
)
if($IsASCII) {$StartValue = 0x0000; $StopValue = 0x007F}
elseif($IsBasicLatin) {$StartValue = 0x0000; $StopValue = 0x007F}
elseif($IsLatin1Supplement) {$StartValue = 0x0080; $StopValue = 0x00FF}
elseif($IsLatinExtendedA) {$StartValue = 0x0100; $StopValue = 0x017F}
elseif($IsLatinExtendedB) {$StartValue = 0x0180; $StopValue = 0x024F}
elseif($IsIPAExtensions) {$StartValue = 0x0250; $StopValue = 0x02AF}
elseif($IsSpacingModifierLetters) {$StartValue = 0x02B0; $StopValue = 0x02FF}
elseif($IsCombiningDiacriticalMarks) {$StartValue = 0x0300; $StopValue = 0x036F}
elseif($IsGreekandCoptic) {$StartValue = 0x0370; $StopValue = 0x03FF}
elseif($IsCyrillic) {$StartValue = 0x0400; $StopValue = 0x04FF}
elseif($IsCyrillicSupplement) {$StartValue = 0x0500; $StopValue = 0x052F}
elseif($IsArmenian) {$StartValue = 0x0530; $StopValue = 0x058F}
elseif($IsHebrew) {$StartValue = 0x0590; $StopValue = 0x05FF}
elseif($IsArabic) {$StartValue = 0x0600; $StopValue = 0x06FF}
elseif($IsSyriac) {$StartValue = 0x0700; $StopValue = 0x074F}
elseif($IsArabicSupplement) {$StartValue = 0x0750; $StopValue = 0x077F}
elseif($IsThaana) {$StartValue = 0x0780; $StopValue = 0x07BF}
elseif($IsNKo) {$StartValue = 0x07C0; $StopValue = 0x07FF}
elseif($IsSamaritan) {$StartValue = 0x0800; $StopValue = 0x083F}
elseif($IsMandaic) {$StartValue = 0x0840; $StopValue = 0x085F}
elseif($IsArabicExtendedA) {$StartValue = 0x08A0; $StopValue = 0x08FF}
elseif($IsDevanagari) {$StartValue = 0x0900; $StopValue = 0x097F}
elseif($IsBengali) {$StartValue = 0x0980; $StopValue = 0x09FF}
elseif($IsGurmukhi) {$StartValue = 0x0A00; $StopValue = 0x0A7F}
elseif($IsGujarati) {$StartValue = 0x0A80; $StopValue = 0x0AFF}
elseif($IsOriya) {$StartValue = 0x0B00; $StopValue = 0x0B7F}
elseif($IsTamil) {$StartValue = 0x0B80; $StopValue = 0x0BFF}
elseif($IsTelugu) {$StartValue = 0x0C00; $StopValue = 0x0C7F}
elseif($IsKannada) {$StartValue = 0x0C80; $StopValue = 0x0CFF}
elseif($IsMalayalam) {$StartValue = 0x0D00; $StopValue = 0x0D7F}
elseif($IsSinhala) {$StartValue = 0x0D80; $StopValue = 0x0DFF}
elseif($IsThai) {$StartValue = 0x0E00; $StopValue = 0x0E7F}
elseif($IsLao) {$StartValue = 0x0E80; $StopValue = 0x0EFF}
elseif($IsTibetan) {$StartValue = 0x0F00; $StopValue = 0x0FFF}
elseif($IsMyanmar) {$StartValue = 0x1000; $StopValue = 0x109F}
elseif($IsGeorgian) {$StartValue = 0x10A0; $StopValue = 0x10FF}
elseif($IsHangulJamo) {$StartValue = 0x1100; $StopValue = 0x11FF}
elseif($IsEthiopic) {$StartValue = 0x1200; $StopValue = 0x137F}
elseif($IsEthiopicSupplement) {$StartValue = 0x1380; $StopValue = 0x139F}
elseif($IsCherokee) {$StartValue = 0x13A0; $StopValue = 0x13FF}
elseif($IsUnifiedCanadianAboriginalSyllabics) {$StartValue = 0x1400; $StopValue = 0x167F}
elseif($IsOgham) {$StartValue = 0x1680; $StopValue = 0x169F}
elseif($IsRunic) {$StartValue = 0x16A0; $StopValue = 0x16FF}
elseif($IsTagalog) {$StartValue = 0x1700; $StopValue = 0x171F}
elseif($IsHanunoo) {$StartValue = 0x1720; $StopValue = 0x173F}
elseif($IsBuhid) {$StartValue = 0x1740; $StopValue = 0x175F}
elseif($IsTagbanwa) {$StartValue = 0x1760; $StopValue = 0x177F}
elseif($IsKhmer) {$StartValue = 0x1780; $StopValue = 0x17FF}
elseif($IsMongolian) {$StartValue = 0x1800; $StopValue = 0x18AF}
elseif($IsUnifiedCanadianAboriginalSyllabicsExtended) {$StartValue = 0x18B0; $StopValue = 0x18FF}
elseif($IsLimbu) {$StartValue = 0x1900; $StopValue = 0x194F}
elseif($IsTaiLe) {$StartValue = 0x1950; $StopValue = 0x197F}
elseif($IsNewTaiLue) {$StartValue = 0x1980; $StopValue = 0x19DF}
elseif($IsKhmerSymbols) {$StartValue = 0x19E0; $StopValue = 0x19FF}
elseif($IsBuginese) {$StartValue = 0x1A00; $StopValue = 0x1A1F}
elseif($IsTaiTham) {$StartValue = 0x1A20; $StopValue = 0x1AAF}
elseif($IsCombiningDiacriticalMarksExtended) {$StartValue = 0x1AB0; $StopValue = 0x1AFF}
elseif($IsBalinese) {$StartValue = 0x1B00; $StopValue = 0x1B7F}
elseif($IsSundanese) {$StartValue = 0x1B80; $StopValue = 0x1BBF}
elseif($IsBatak) {$StartValue = 0x1BC0; $StopValue = 0x1BFF}
elseif($IsLepcha) {$StartValue = 0x1C00; $StopValue = 0x1C4F}
elseif($IsOlChiki) {$StartValue = 0x1C50; $StopValue = 0x1C7F}
elseif($IsSundaneseSupplement) {$StartValue = 0x1CC0; $StopValue = 0x1CCF}
elseif($IsVedicExtensions) {$StartValue = 0x1CD0; $StopValue = 0x1CFF}
elseif($IsPhoneticExtensions) {$StartValue = 0x1D00; $StopValue = 0x1D7F}
elseif($IsPhoneticExtensionsSupplement) {$StartValue = 0x1D80; $StopValue = 0x1DBF}
elseif($IsCombiningDiacriticalMarksSupplement) {$StartValue = 0x1DC0; $StopValue = 0x1DFF}
elseif($IsLatinExtendedAdditional) {$StartValue = 0x1E00; $StopValue = 0x1EFF}
elseif($IsGreekExtended) {$StartValue = 0x1F00; $StopValue = 0x1FFF}
elseif($IsGeneralPunctuation) {$StartValue = 0x2000; $StopValue = 0x206F}
elseif($IsSuperscriptsandSubscripts) {$StartValue = 0x2070; $StopValue = 0x209F}
elseif($IsCurrencySymbols) {$StartValue = 0x20A0; $StopValue = 0x20CF}
elseif($IsCombiningDiacriticalMarksforSymbols) {$StartValue = 0x20D0; $StopValue = 0x20FF}
elseif($IsLetterlikeSymbols) {$StartValue = 0x2100; $StopValue = 0x214F}
elseif($IsNumberForms) {$StartValue = 0x2150; $StopValue = 0x218F}
elseif($IsArrows) {$StartValue = 0x2190; $StopValue = 0x21FF}
elseif($IsMathematicalOperators) {$StartValue = 0x2200; $StopValue = 0x22FF}
elseif($IsMiscellaneousTechnical) {$StartValue = 0x2300; $StopValue = 0x23FF}
elseif($IsControlPictures) {$StartValue = 0x2400; $StopValue = 0x243F}
elseif($IsOpticalCharacterRecognition) {$StartValue = 0x2440; $StopValue = 0x245F}
elseif($IsEnclosedAlphanumerics) {$StartValue = 0x2460; $StopValue = 0x24FF}
elseif($IsBoxDrawing) {$StartValue = 0x2500; $StopValue = 0x257F}
elseif($IsBlockElements) {$StartValue = 0x2580; $StopValue = 0x259F}
elseif($IsGeometricShapes) {$StartValue = 0x25A0; $StopValue = 0x25FF}
elseif($IsMiscellaneousSymbols) {$StartValue = 0x2600; $StopValue = 0x26FF}
elseif($IsDingbats) {$StartValue = 0x2700; $StopValue = 0x27BF}
elseif($IsMiscellaneousMathematicalSymbolsA) {$StartValue = 0x27C0; $StopValue = 0x27EF}
elseif($IsSupplementalArrowsA) {$StartValue = 0x27F0; $StopValue = 0x27FF}
elseif($IsBraillePatterns) {$StartValue = 0x2800; $StopValue = 0x28FF}
elseif($IsSupplementalArrowsB) {$StartValue = 0x2900; $StopValue = 0x297F}
elseif($IsMiscellaneousMathematicalSymbolsB) {$StartValue = 0x2980; $StopValue = 0x29FF}
elseif($IsSupplementalMathematicalOperators) {$StartValue = 0x2A00; $StopValue = 0x2AFF}
elseif($IsMiscellaneousSymbolsandArrows) {$StartValue = 0x2B00; $StopValue = 0x2BFF}
elseif($IsGlagolitic) {$StartValue = 0x2C00; $StopValue = 0x2C5F}
elseif($IsLatinExtendedC) {$StartValue = 0x2C60; $StopValue = 0x2C7F}
elseif($IsCoptic) {$StartValue = 0x2C80; $StopValue = 0x2CFF}
elseif($IsGeorgianSupplement) {$StartValue = 0x2D00; $StopValue = 0x2D2F}
elseif($IsTifinagh) {$StartValue = 0x2D30; $StopValue = 0x2D7F}
elseif($IsEthiopicExtended) {$StartValue = 0x2D80; $StopValue = 0x2DDF}
elseif($IsCyrillicExtendedA) {$StartValue = 0x2DE0; $StopValue = 0x2DFF}
elseif($IsSupplementalPunctuation) {$StartValue = 0x2E00; $StopValue = 0x2E7F}
elseif($IsCJKRadicalsSupplement) {$StartValue = 0x2E80; $StopValue = 0x2EFF}
elseif($IsKangxiRadicals) {$StartValue = 0x2F00; $StopValue = 0x2FDF}
elseif($IsIdeographicDescriptionCharacters) {$StartValue = 0x2FF0; $StopValue = 0x2FFF}
elseif($IsCJKSymbolsandPunctuation) {$StartValue = 0x3000; $StopValue = 0x303F}
elseif($IsHiragana) {$StartValue = 0x3040; $StopValue = 0x309F}
elseif($IsKatakana) {$StartValue = 0x30A0; $StopValue = 0x30FF}
elseif($IsBopomofo) {$StartValue = 0x3100; $StopValue = 0x312F}
elseif($IsHangulCompatibilityJamo) {$StartValue = 0x3130; $StopValue = 0x318F}
elseif($IsKanbun) {$StartValue = 0x3190; $StopValue = 0x319F}
elseif($IsBopomofoExtended) {$StartValue = 0x31A0; $StopValue = 0x31BF}
elseif($IsCJKStrokes) {$StartValue = 0x31C0; $StopValue = 0x31EF}
elseif($IsKatakanaPhoneticExtensions) {$StartValue = 0x31F0; $StopValue = 0x31FF}
elseif($IsEnclosedCJKLettersandMonths) {$StartValue = 0x3200; $StopValue = 0x32FF}
elseif($IsCJKCompatibility) {$StartValue = 0x3300; $StopValue = 0x33FF}
elseif($IsCJKUnifiedIdeographsExtensionA) {$StartValue = 0x3400; $StopValue = 0x4DBF}
elseif($IsYijingHexagramSymbols) {$StartValue = 0x4DC0; $StopValue = 0x4DFF}
elseif($IsCJKUnifiedIdeographs) {$StartValue = 0x4E00; $StopValue = 0x9FFF}
elseif($IsYiSyllables) {$StartValue = 0xA000; $StopValue = 0xA48F}
elseif($IsYiRadicals) {$StartValue = 0xA490; $StopValue = 0xA4CF}
elseif($IsLisu) {$StartValue = 0xA4D0; $StopValue = 0xA4FF}
elseif($IsVai) {$StartValue = 0xA500; $StopValue = 0xA63F}
elseif($IsCyrillicExtendedB) {$StartValue = 0xA640; $StopValue = 0xA69F}
elseif($IsBamum) {$StartValue = 0xA6A0; $StopValue = 0xA6FF}
elseif($IsModifierToneLetters) {$StartValue = 0xA700; $StopValue = 0xA71F}
elseif($IsLatinExtendedD) {$StartValue = 0xA720; $StopValue = 0xA7FF}
elseif($IsSylotiNagri) {$StartValue = 0xA800; $StopValue = 0xA82F}
elseif($IsCommonIndicNumberForms) {$StartValue = 0xA830; $StopValue = 0xA83F}
elseif($IsPhagspa) {$StartValue = 0xA840; $StopValue = 0xA87F}
elseif($IsSaurashtra) {$StartValue = 0xA880; $StopValue = 0xA8DF}
elseif($IsDevanagariExtended) {$StartValue = 0xA8E0; $StopValue = 0xA8FF}
elseif($IsKayahLi) {$StartValue = 0xA900; $StopValue = 0xA92F}
elseif($IsRejang) {$StartValue = 0xA930; $StopValue = 0xA95F}
elseif($IsHangulJamoExtendedA) {$StartValue = 0xA960; $StopValue = 0xA97F}
elseif($IsJavanese) {$StartValue = 0xA980; $StopValue = 0xA9DF}
elseif($IsMyanmarExtendedB) {$StartValue = 0xA9E0; $StopValue = 0xA9FF}
elseif($IsCham) {$StartValue = 0xAA00; $StopValue = 0xAA5F}
elseif($IsMyanmarExtendedA) {$StartValue = 0xAA60; $StopValue = 0xAA7F}
elseif($IsTaiViet) {$StartValue = 0xAA80; $StopValue = 0xAADF}
elseif($IsMeeteiMayekExtensions) {$StartValue = 0xAAE0; $StopValue = 0xAAFF}
elseif($IsEthiopicExtendedA) {$StartValue = 0xAB00; $StopValue = 0xAB2F}
elseif($IsLatinExtendedE) {$StartValue = 0xAB30; $StopValue = 0xAB6F}
elseif($IsMeeteiMayek) {$StartValue = 0xABC0; $StopValue = 0xABFF}
elseif($IsHangulSyllables) {$StartValue = 0xAC00; $StopValue = 0xD7AF}
elseif($IsHangulJamoExtendedB) {$StartValue = 0xD7B0; $StopValue = 0xD7FF}
elseif($IsHighSurrogates) {$StartValue = 0xD800; $StopValue = 0xDB7F}
elseif($IsHighPrivateUseSurrogates) {$StartValue = 0xDB80; $StopValue = 0xDBFF}
elseif($IsLowSurrogates) {$StartValue = 0xDC00; $StopValue = 0xDFFF}
elseif($IsPrivateUseArea) {$StartValue = 0xE000; $StopValue = 0xF8FF}
elseif($IsCJKCompatibilityIdeographs) {$StartValue = 0xF900; $StopValue = 0xFAFF}
elseif($IsAlphabeticPresentationForms) {$StartValue = 0xFB00; $StopValue = 0xFB4F}
elseif($IsArabicPresentationFormsA) {$StartValue = 0xFB50; $StopValue = 0xFDFF}
elseif($IsVariationSelectors) {$StartValue = 0xFE00; $StopValue = 0xFE0F}
elseif($IsVerticalForms) {$StartValue = 0xFE10; $StopValue = 0xFE1F}
elseif($IsCombiningHalfMarks) {$StartValue = 0xFE20; $StopValue = 0xFE2F}
elseif($IsCJKCompatibilityForms) {$StartValue = 0xFE30; $StopValue = 0xFE4F}
elseif($IsSmallFormVariants) {$StartValue = 0xFE50; $StopValue = 0xFE6F}
elseif($IsArabicPresentationFormsB) {$StartValue = 0xFE70; $StopValue = 0xFEFF}
elseif($IsHalfwidthandFullwidthForms) {$StartValue = 0xFF00; $StopValue = 0xFFEF}
elseif($IsSpecials) {$StartValue = 0xFFF0; $StopValue = 0xFFFF}
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
Invalid
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
        IsASCII         = $_ -le 127
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
