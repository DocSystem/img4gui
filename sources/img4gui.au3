#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=images\shsh-blobs.ico
#AutoIt3Wrapper_Res_Comment=An img4tool GUI powered by DocSystem
#AutoIt3Wrapper_Res_Description=An img4tool GUI
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=img4gui
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Res_File_Add=img4tool.exe
#AutoIt3Wrapper_Res_File_Add=tsschecker.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <Constants.au3>
#include <FileConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <file.au3>


#Region ### START Koda GUI section ### Form=C:\Users\Antoine\Desktop\img4toolGUI\img4gui.kxf
$img4gui = GUICreate("img4gui - An img4tool GUI", 321, 504, 681, 231)
$WelcomeLabel = GUICtrlCreateLabel("Bienvenue sur img4gui", 0, 0, 320, 41, $SS_CENTER)
GUICtrlSetFont(-1, 23, 400, 0, "MS Sans Serif")
$WindowControl = GUICtrlCreateTab(8, 40, 305, 457)
$BlobTester = GUICtrlCreateTabItem("Tester des blobs")
$BlobSelector = GUICtrlCreateButton("Choisir un fichier blobs", 68, 107, 171, 25)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$BMSelector = GUICtrlCreateButton("Chosir un BuildManifest.plist", 68, 163, 171, 25)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$StartTest = GUICtrlCreateButton("Lancer le test", 92, 219, 123, 41)
GUICtrlSetFont(-1, 13, 400, 0, "Arial")
$BlobDL = GUICtrlCreateTabItem("Télécharger des blobs")
GUICtrlSetState(-1,$GUI_SHOW)
$ECIDInput = GUICtrlCreateInput("", 152, 112, 121, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$ECIDEnter = GUICtrlCreateLabel("ECID :", 112, 112, 42, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$ModelSelector = GUICtrlCreateCombo("", 152, 160, 121, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$ModelEnter = GUICtrlCreateLabel("Modèle : ", 96, 160, 58, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$BoardInput = GUICtrlCreateInput("", 152, 208, 121, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$BoardEnter = GUICtrlCreateLabel("Board Config (iPhone) : ", 16, 208, 142, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$iOSInput = GUICtrlCreateInput("", 152, 256, 121, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$iOSEnter = GUICtrlCreateLabel("Version d'iOS : ", 64, 256, 95, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$iOSLatest = GUICtrlCreateCheckbox("Dernière version ?", 104, 288, 129, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$StartDL = GUICtrlCreateButton("Télécharger blobs", 92, 323, 139, 41)
GUICtrlSetFont(-1, 13, 400, 0, "Arial")
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


$filename = @TempDir & "\logimg4gui.txt"


Local $sBlobsDialog = "nope"
Local $sBMDialog = "nope"


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Run(@ComSpec & " /c " & 'del ' & @TempDir & '\logimg4gui.txt', "", @SW_HIDE)
			Exit

		Case $BlobSelector
			$sBlobsDialog = FileOpenDialog("", @WorkingDir & "\", "Blobs (*.plist;*.shsh;*.shsh2)", $FD_FILEMUSTEXIST)

		Case $BMSelector
			$sBMDialog = FileOpenDialog("", @WorkingDir & "\", "BuildManifest.plist (BuildManifest.plist)", $FD_FILEMUSTEXIST)

		Case $StartTest
			Dim $valeur = "[IMG4TOOL] file is valid!", $i, $text
			If $sBlobsDialog <> "nope" Then
				If $sBMDialog <> "nope" Then
					Local $foo = Run(@ComSpec & " /c " & 'img4tool.exe -v ' & $sBMDialog & ' -s ' & $sBlobsDialog & '>' & @TempDir & '\logimg4gui.txt', "", @SW_HIDE)
					verify()

				Else
					MsgBox(4096, "img4gui - Erreur", "Merci de séléctionner un BuildManifest.plist", 0)
				EndIf
			Else
				MsgBox(4096, "img4gui - Erreur", "Merci de séléctionner un Blob", 0)
			EndIf

		Case $StartDL

			Dim $valeur = "IS being signed!", $i, $text
			$LatestVerStatus = BitAND(GUICtrlRead($iOSLatest), $GUI_CHECKED)
			Local $ECID = GUICtrlRead($ECIDInput)
			Local $Model = GUICtrlRead($ModelSelector)
			Local $Board = GUICtrlRead($BoardInput)
			Local $iOS = GUICtrlRead($iOSInput)

			If $ECID <> "" Then
				If $Model <> "" Then
					If $Board <> "" Then
						If $iOS <> "" Then
							Local $foo = Run(@ComSpec & " /c " & 'tsschecker.exe -e ' & $ECID & ' -d ' & $Model & ' -B ' & $Board & ' -i ' & $iOS & ' -s >' & @TempDir & '\logimg4gui.txt', "", @SW_HIDE)
							download()

						ElseIf $LatestVerStatus = True Then
							Local $foo = Run(@ComSpec & " /c " & 'tsschecker.exe -e ' & $ECID & ' -d ' & $Model & ' -B ' & $Board & ' -l -s >' & @TempDir & '\logimg4gui.txt', "", @SW_HIDE)
							download()

						Else
							MsgBox(4096, "img4gui - Erreur", "Merci de choisir une version d'iOS", 0)

						EndIf
					Else
						If $iOS <> "" Then
							Local $foo = Run(@ComSpec & " /c " & 'tsschecker.exe -e ' & $ECID & ' -d ' & $Model & ' -i ' & $iOS & ' -s >' & @TempDir & '\logimg4gui.txt', "", @SW_HIDE)
							download()

						ElseIf $LatestVerStatus = True Then
							Local $foo = Run(@ComSpec & " /c " & 'tsschecker.exe -e ' & $ECID & ' -d ' & $Model & ' -l -s >' & @TempDir & '\logimg4gui.txt', "", @SW_HIDE)
							download()

						Else
							MsgBox(4096, "img4gui - Erreur", "Merci de choisir une version d'iOS", 0)

						EndIf
					EndIf
				Else
					MsgBox(4096, "img4gui - Erreur", "Merci d'entrer un modèle", 0)

				EndIf
			Else
				MsgBox(4096, "img4gui - Erreur", "Merci d'entrer un ECID", 0)

		EndIf
	EndSwitch
WEnd


Func verify()

	ProcessWaitClose($foo)

	If _ReplaceStringInFile($filename, $valeur, $valeur) Then
		MsgBox(4096, "img4gui - Vérification terminée", "Le blob séléctionné est valide pour cette version d'iOS", 0)

	Else ; SI LA CHAINE N'EST PAS TROUVEE
		MsgBox(4096, "img4gui - Vérification terminée", "Le blob séléctionné n'est pas valide pour cette version d'iOS", 0)

	EndIf

EndFunc

Func download()

	ProcessWaitClose($foo)

	If _ReplaceStringInFile($filename, $valeur, $valeur) Then
		MsgBox(4096, "img4gui - Vérification terminée", "Le blob demandé a été téléchargé", 0)

	Else ; SI LA CHAINE N'EST PAS TROUVEE
		MsgBox(4096, "img4gui - Vérification terminée", "Le blob demandé n'as pas pu être téléchargé", 0)

	EndIf

EndFunc
