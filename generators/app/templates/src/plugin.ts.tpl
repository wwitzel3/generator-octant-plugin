import * as octant from "./octant/plugin";
import * as c from "./octant/components";

let podGVK = {version: "v1", kind: "Pod"}

export default class MyPlugin implements octant.Plugin {
    name = "<%= filename %>";
    description = "<%= description %>";
    isModule = <%= isModule %>;
    actionCount = 0;
    currentNamespace = ""

    capabilities = {
        supportPrinterConfig: [podGVK],
        supportTab: [podGVK],
        actionNames: [
            "<%= filename %>/testAction",
            "action.octant.dev/setNamespace",
        ],
    };

    printHandler(request: octant.ObjectRequest): octant.PrintResponse {
        return {
            config: [{
                header: "from-plugin-foo",
                content: c.createText("my **bold** and *emphisized* text", true),
            }],
        };
    }

    actionHandler(request: octant.ActionRequest): octant.ActionResponse {
        if (request.actionName === "<%= filename %>/testAction") {
            this.actionCount += 1;
        }

        if (request.actionName === "action.octant.dev/setNamespace") {
            this.currentNamespace = request.payload.namespace;
        }
        return
    }

    tabHandler(request: octant.ObjectRequest): octant.TabResponse {
        return {
            tab: {
                name: "<%= name %>",
                contents: {
                    config: {
                        sections: [[{
                            width: c.Width.Half,
                            height: c.Width.Half,
                            view: {
                                metadata: {
                                    type: "card"
                                },
                                config: {
                                    body: c.createText("card body"),
                                }
                            } as octant.CardView
                        }, {
                            width: c.Width.Half,
                            height: c.Width.Half,
                            view: {
                                metadata: {
                                    type: "card"
                                },
                                config: {
                                    body: c.createText("card body"),
                                }
                            } as octant.CardView
                        }]],
                        /*
                        buttonGroup: {
                            config: {
                                buttons: [{
                                    name: "Test",
                                    payload: {action: "<%= filename %>/testAction", foo: "bar"},
                                    confirmation: {
                                        title: "Confirmation?",
                                        body: "Confirm this button click"
                                    },
                                }]
                            },
                            metadata: {
                                type: "buttonGroup"
                            }
                        } as octant.ButtonGroupView
                        */
                    },
                    metadata: {
                        type: "flexlayout"
                    }
                } as octant.FlexLayoutView,
            }
        }
    }

    navigationHandler(): octant.Navigation {
        let nav = new c.Navigation("TS Plugin", "<%= filename %>", "cloud");
        nav.add("test menu flyout", "nested-path", "folder")
        return nav;
    }

    contentHandler(request: octant.ContentRequest): octant.ContentResponse {
        let contentPath = request.contentPath;
        let title = [c.createText("<%= name %>")];
        if (contentPath.length > 0) {
            title.push(c.createText(contentPath))
        }

        return {
            content: {
                title: title,
                viewComponents: [{
                        metadata: {
                            type: "card",
                            accessor: "card-1",
                            title: [c.createText("Card 1")]
                        },
                        config: {
                            body: c.createText("card body 1\n" +
                            contentPath + "\n" +
                            " **actionCallCount:** " + this.actionCount + "\n" +
                            "currentNamespace: " + this.currentNamespace + "\n", true),
                        }
                    } as octant.CardView,
                    {
                        metadata: {
                            type: "card",
                            accessor: "card-2",
                            title: [c.createText("Card 2")]
                        },
                        config: {
                            body: c.createText("card body 2" + contentPath),
                        }
                    } as octant.CardView
                ],
                buttonGroup: {
                    config: {
                        buttons: [{
                            name: "Test",
                            payload: {action: "<%= filename %>/testAction", foo: "bar"},
                            confirmation: {
                                title: "Confirmation?",
                                body: "Confirm this button click"
                            },
                        }]
                    },
                    metadata: {
                        type: "buttonGroup"
                    }
                } as octant.ButtonGroupView
            }
        }
    }
}

console.log("loading <%= filename %>.ts");
