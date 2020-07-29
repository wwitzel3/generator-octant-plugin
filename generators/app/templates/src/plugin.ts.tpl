// core-js and regenerator-runtime are requried to ensure the correct polyfills
// are applied by babel/webpack.
import "core-js/stable";
import "regenerator-runtime/runtime";

// plugin contains interfaces your plugin can expect
// this includes your main plugin class, response, requests, and clients.
import * as octant from "./octant/plugin";

// components containers helpers for generating the
// objects that Octant can render to components.
import * as c from "./octant/components";

// rxjs is used to show that Observables function within
// the Octant JavaScript runtime.
import { Subject, BehaviorSubject } from 'rxjs';

// This plugin will handle v1/Pod types.
let podGVK = {version: "v1", kind: "Pod"}

export default class MyPlugin implements octant.Plugin {
    // Static fields that Octant uses
    name = "<%= filename %>";
    description = "<%= description %>";

    // If true, the contentHandler and navigationHandler will be called.
    isModule = <%= isModule %>;

    // Octant will assign these via the constructor at runtime.
    dashboardClient: octant.DashboardClient;
    httpClient: octant.HTTPClient;

    // Plugin capabilities
    capabilities = {
        supportPrinterConfig: [podGVK],
        supportTab: [podGVK],
        actionNames: [
            "<%= filename %>/testAction",
            "action.octant.dev/setNamespace",
        ],
    };

    // Custom plugin properties
    actionCount: number;
    currentNamespace: Subject<string>;

    // Octant expects plugin constructors to accept two arguments, the dashboardClient and the httpClient
    constructor(dashboardClient: octant.DashboardClient, httpClient: octant.HTTPClient) {
        this.dashboardClient = dashboardClient;
        this.httpClient = httpClient;

        // set intial actionCount
        this.actionCount = 0;
        this.currentNamespace = new BehaviorSubject("default");
    }

    printHandler(request: octant.ObjectRequest): octant.PrintResponse {
        return {
            config: [{
                header: "from-plugin-foo",
                content: c.createText("my **bold** and *emphisized* text", true),
            }],
        };
    }

    actionHandler(request: octant.ActionRequest): octant.ActionResponse | void {
        if (request.actionName === "<%= filename %>/testAction") {
            this.actionCount += 1;
            return;
        }

        if (request.actionName === "action.octant.dev/setNamespace") {
            this.currentNamespace.next(request.payload.namespace);
            return;
        }

        return;
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
        nav.add("test menu flyout", "nested-path", "folder");
        return nav;
    }

    contentHandler(request: octant.ContentRequest): octant.ContentResponse {
        let contentPath = request.contentPath;
        let title = [c.createText("<%= name %>")];
        if (contentPath.length > 0) {
            title.push(c.createText(contentPath));
        }

        let namespace = "<unknown>";
        this.currentNamespace.subscribe(data => {
            namespace = data;
        })

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
                            "currentNamespace: " + namespace + "\n", true),
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
