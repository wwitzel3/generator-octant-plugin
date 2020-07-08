import * as octant from "./octant/plugin";
import * as c from "./octant/components";

let podGVK = {version: "v1", kind: "Pod"}

export default class MyPlugin implements octant.Plugin {
    name = "<%= name %>";
    description = "<%= description %>";
    isModule = <%= isModule %>;

    capabilities = {
        supportPrinterConfig: [podGVK],
    };

    printHandler(request: octant.PrintRequest): octant.PrintResponse {
        return {
            config: [{
                header: "from-plugin",
                content: c.createText("my **bold** and *emphisized* text", true),
            }],
        };
    }
}

console.log("loading <%= filename %>.ts");
