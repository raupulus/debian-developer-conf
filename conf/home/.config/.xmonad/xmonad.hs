import XMonad
import XMonad.Config.Gnome
import XMonad.Util.EZConfig

myModMask     = mod4Mask
myBorderWidth = 1
myTerminal    = "tilix"
myWorkspaces  = [
          "Terminales"
        , "WEB"
        , "Redes"
        , "DIR"
    ]
myNormalBorderColor = "#dddddd"
myFocusedBorderColor = "#ff0000"

main = xmonad $ gnomeConfig
    -- xmproc <- spawnPipe "xmobar"
    -- spawn "nitrogen --restore"
    -- spawn "plank"
    {
          modMask     = myModMask
        , borderWidth = myBorderWidth
        , terminal    = myTerminal
        , workspaces  = myWorkspaces
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
    }
    `additionalKeysP`
        [
        -- Moverse por los espacios de Trabajo con flechas
        --  ("M-<Left>", prevWS )
        --, ("M-<Right>", nextWS )
        --, ("M-S-<Left>", shiftToPrev )
        --, ("M-S-<Right>", shiftToNext)

        -- MOD+q Muestra salida de sesion
        ("M-q",   spawn "gnome-session-quit --logout")
        -- MOD+shift+q Muestra menu de apagado
        , ("M-S-q", spawn "gnome-session-quit --power-off")
        ]
