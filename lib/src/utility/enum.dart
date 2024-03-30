enum HeaderTabs {
  project,
  projectParts,
  imageGroups,
  objectLabeling,
  addProject,
  addGroup,
  addPart,
  export
}

enum GroupState {
  none,
  generated,
  findMainState,
  editOtherStates,
  findSubObjects,
  finishCutting,
  readyToWork,
  finished
}

enum ObjectType {
  label,
  linkLabel,
  button,
  closeBTN,
  confirmBTN,
  confirmAndCloseBTN,
  iconBTN,
  textBox,
  switchBTN,
  checkBox,
  radioRegion,
  icon,
  colorView,
  richEditBox,
  menu,
  menuItem,
  tab,
  selectBox,
  table,
  tableColumn,
  tableRow,
  cell,
  horizontalScrollbar,
  verticalScrollbar,
  chart,
  chartObjects,
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
