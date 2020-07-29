import * as octant from "./plugin";

export enum Width {
  Half = 12,
  Full = 24,
}

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

export function createLink(
  value: string,
  ref: string
): octant.LinkView {
  return {
    metadata: {
      type: "link",
    },
    config: {
      value: value,
      ref: ref
    },
  };
}

export function createGridAction(name: string, actionPath: string, payload: {[key: string]: string}, confirmation?: octant.Confirmation, type?: string): octant.GridAction {
  return {
          actionPath: actionPath,
          name: name,
          payload: payload,
          type: type,
          confirmation: confirmation,
  }
}

export class Navigation implements octant.Navigation {
  title: string;
  path: string;
  iconName?: string;

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

export class FlexLayout implements octant.FlexLayoutView {
  config: {
    sections: octant.FlexLayoutItem[][];
    buttonGroup?: octant.ButtonGroupView;
  };

  metadata = {
    type: "flexlayout",
    accessor: "",
    title: [] as octant.View[],
  }

  constructor(title: string) {
    this.metadata.accessor = title.toLowerCase();
    this.metadata.title = [{
      metadata: {
        type: "text"
      },
      config: {
        value: title
      },
    } as octant.View];
    this.config = {
      sections: [],
    }
  }

  addSection(items: octant.FlexLayoutItem[]) {
    this.config.sections.push(items)
  }
}

export class Table implements octant.TableView {
  metadata = {
    type: "table",
    title: [] as octant.View[],
  }

  config: {
    columns: octant.TableColumn[];
    rows: octant.TableRow[];
    emptyContent: string;
    loading: boolean;
    filters: octant.TableFilters;
  }

  constructor(title: octant.View[], columns?: octant.TableColumn[], rows?: octant.TableRow[], emptyMsg?: string) {
    this.config = {
      columns: [],
      rows: [],
      emptyContent: "No results.",
      filters: {},
      loading: false,
    }

    this.metadata.title = title;

    if (columns !== undefined) {
      this.config.columns = columns;
    }

    if (rows !== undefined) {
      rows.forEach((v: octant.TableRow, i: number) => {
        this.config.rows.push(v);
      })
    }

    if (emptyMsg !== undefined) {
      this.config.emptyContent = emptyMsg;
    }
  }

  addRow(row: octant.TableRow, gridActions?: octant.GridAction[]) {
    let r = row as any;
    if (gridActions !== undefined) {
      r["_action"] = {metadata: {type: "gridActions"}, config: {
        actions: gridActions
      }}
    }
    this.config.rows.push(r);
  }
}
