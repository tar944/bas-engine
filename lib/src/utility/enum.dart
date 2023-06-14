enum PageType { mainPage, subPage, dialog, menu, submenu, rightMenu,openDialog,saveDialog }

enum PartType {
  menuBar,
  statusBar,
  optionBox,
  toolsBar,
  toolsPallet,
  menu,
  submenu,
  rightClick,
  tabBar,
  tabBody
}

enum ObjectType {
  checkRegion,
  label,
  button,
  radioRegion,
  icon,
  iconBTN,
  tab,
  switchBTN,
  selectBox,
  table,
  chart,
  menu,
  menuItem,
  cell,
  textBox,
  richEditBox
}

enum ImageStatus { finished, created }

enum ActionKind {
  nothing,
  selectMulti,
  selectOne,
  click,
  doubleClick,
  wheelDown,
  wheelUp,
  rightClick,
  slideRight,
  slideLeft,
  scrollHorizontal,
  scrollVertical,
  type,
  dragAndDropUpAndDown,
  dragAndDropLeftAndRight,
  dragAndDrop,
  hold,
  typeNumber
}
