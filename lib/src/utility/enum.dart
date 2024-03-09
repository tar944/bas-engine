enum HeaderTabs {
  project,
  projectParts,
  imageGroups,
  objectLabeling,
  addProject,
  addGroup,
  addPart}

enum ObjectType {
  checkRegion,
  label,
  button,
  closeBTN,
  confirmBTN,
  confirmAndCloseBTN,
  radioRegion,
  icon,
  iconBTN,
  tab,
  switchBTN,
  selectBox,
  table,
  tableColumn,
  tableRow,
  horizontalScrollbar,
  verticalScrollbar,
  chart,
  chartObjects,
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
