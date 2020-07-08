export interface Key {
    namespace: string
    apiVersion: string
    kind: string
    name: string
}

export interface PrintRequest {
    client: DashboardClient
    objectKey: Key
}

export interface PrintResponse {
    config?: any[];
    status?: any[];
    items?: any[];
}

export interface DashboardClient {
    Get(key: Key): any
}

export interface Plugin {
    name: string;
    description: string;
    isModule: boolean;

    capabilities: Capabilities;

    tabHandler?: () => any;
    printHandler?: (PrintRequest) => PrintResponse;
    objectStatusHandler?: () => any;
}

export interface GroupVersionKind {
    group?: string,
    version: string,
    kind: string,
}

export interface Capabilities {
    supportPrinterConfig?: GroupVersionKind[];
    supportPrinterStatus?: GroupVersionKind[];
    supportPrinterItems?: GroupVersionKind[];
    supportObjectStatus?: GroupVersionKind[];
    supportTab?: GroupVersionKind[];
}
