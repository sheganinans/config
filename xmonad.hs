import XMonad
-- import XMonad.Hooks.DynamicLog
-- import XMonad.Util.Run (spawnPipe)
import System.Exit

import qualified Data.Map as M
import qualified XMonad.StackSet as W

main = do
  --xmproc <- spawnPipe "xmobar /home/aistis/.xmobarrc"
  xmonad defaults

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
myNormalBorder = "#dddddd"
myFocusedBorder = "#ff0000"
myBar = "xmobar"
-- myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }
myStartupHook = return ()
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [ ((modm              , xK_t     ), spawn "xterm -sl 10000")
  , ((modm              , xK_p     ), spawn "dmenu_run")
  , ((modm .|. shiftMask, xK_c     ), kill)
  , ((modm              , xK_space ), sendMessage NextLayout)
  , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
  , ((modm              , xK_n     ), refresh)
  , ((modm              , xK_Tab   ), windows W.focusDown)
  , ((modm              , xK_j     ), windows W.focusDown)
  , ((modm              , xK_k     ), windows W.focusUp)
  , ((modm              , xK_m     ), windows W.focusMaster)
  , ((modm              , xK_Return), windows W.swapMaster)
  , ((modm .|. shiftMask, xK_j     ), windows W.swapDown)
  , ((modm .|. shiftMask, xK_k     ), windows W.swapUp)
  , ((modm              , xK_h     ), sendMessage Shrink)
  , ((modm              , xK_l     ), sendMessage Expand)
  , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
  , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
  , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
  , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
  , ((modm              , xK_f     ), spawn "firefox")
  ]
  ++
  [((m .|. modm, k), windows $ f i)
    | (i,k) <- zip (XMonad.workspaces conf) [xK_1..xK_9]
    , (f,m) <- [(W.greedyView, 0),(W.shift, shiftMask)]]


defaults = defaultConfig
  { terminal = "urxvt"
  , modMask = mod4Mask
  , borderWidth = 1
  , workspaces = myWorkspaces
  , normalBorderColor = myNormalBorder
  , focusedBorderColor = myFocusedBorder
  , keys = myKeys
  , startupHook = myStartupHook
  }
