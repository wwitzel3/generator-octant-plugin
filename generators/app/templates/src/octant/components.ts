import * as octant from "./plugin";

export function createText(
  value: string,
  isMarkdown?: boolean
): octant.TextView {
  return {
    metadata: {
      type: "text",
    },
    config: {
      value: value,
      isMarkdown: isMarkdown,
    },
  };
}

export class Navigation implements octant.Navigation {
  title: string;
  path: string;
  iconName: string;

  children: octant.Navigation[];

  constructor(title: string, path: string, icon?: string) {
    this.title = title;
    this.path = "/" + path;
    this.iconName = icon;
    this.children = [];
  }

  add(title: string, path: string, icon?: string) {
    this.children.push({
      title: title,
      path: this.path + "/" + path,
      iconName: icon,
    });
  }
}

/*
export class FlexLayout implements octant.FlexLayoutView {
  config: {
    sections: octant.FlexLayoutItem[][];
    buttonGroup: octant.ButtonGroupView;
  };
  metadata: octant.Metadata;

  constructor() {}

  addSection() {
  }
}
*/

export enum Width {
  Half = 12,
  Full = 24,
}
