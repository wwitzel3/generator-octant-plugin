import * as octant from "./octant";

let podGVK = {version: "v1", kind: "Pod"}

export default class MyPlugin implements octant.Plugin {
    name = "<%= name %>";
    description = "<%= description %>";
    isModule = <%= isModule %>;

    capabilities = {
        supportPrinterConfig: [podGVK],
        supportPrinterItems: [podGVK],
    };

    printHandler(request: octant.PrintRequest): octant.PrintResponse {
        return {
            config: [{
                header: "from-plugin",
                content: {
                    metadata: {type: "text"},
                    config: {value: "lorem ipsum"}
                }
            }],
            items: [{
                width: 12,
                height: null,
                view: {
                    config: {
                        sections: [{
                            header: "Half Width",
                            content: {
                                config: { value: "sample text" },
                                metadata: { type: "text" },
                            },
                        }],
                        actions: [],
                    },
                    metadata: { type: "summary" },
                },
            }],
        };
    }
}

console.log("loading <%= filename %>.ts");
