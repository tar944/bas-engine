enum DefaultActions {
  choseAction,
  watch,
  click,
  rightClick,
  doubleClick,
  type,
  typeNumber,
  dragAndDrop,
  scrollUpOrDown,
  scrollRightOrLeft,
  selectOne,
  selectMulti,
}

enum NavDuties{
  scrollUp,
  scrollDown,
  scrollUpOrDown,
  scrollRightOrLeft,
  scrollRight,
  scrollLeft,
  zoomIn,
  zoomOut,
  zoomInOrOut,
  confirmAndClose,
  close,
}

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
  label__watch,
  linkLabel__click,
  button__click,
  closeBTN__click,
  confirmBTN__click,
  confirmAndCloseBTN__click,
  iconBTN__click,
  textBox__type,
  switchBTN__click,
  checkBox__selectMulty,
  radioRegion__selectOne,
  icon__watch,
  colorView__watch,
  richEditBox__type,
  menuItem__click,
  itemWithSubMenu__click,
  tab__click,
  selectBox__click,
  table__watch,
  tableColumn__watch,
  tableRow__watch,
  cell__click,
  horizontalScrollbar__scrollRightOrLeft,
  verticalScrollbar__scrollUpOrDown,
  chart__watch,
  chartObjects__click,
}

enum Windows{
  page,
  dialog,
  tabPage
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
