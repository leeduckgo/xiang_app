// esbuild automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "config.exs".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket

window.addEventListener(
    "phx:reset-xiang-graph",
    e => {
        s.clear(); //clear the snap
        var head = s.rect(200, begin_point, 20, 20, 5).attr(
            {
                fill: "#eb4034",
                stroke: "#000",
                strokeWidth: 5
            });
        var body = s.rect(200, begin_point + 20, 20, default_length, 5).attr(
            {
                fill: "#ebc034",
                stroke: "#000",
                strokeWidth: 5
            });
    }
)
window.addEventListener(
    "phx:update-xiang-graph",
    e => {
        s.clear(); //clear the snap
        head_point = default_length - e.detail.length_xiang
        var c = s.image("images/smoke.gif", 170, 0, 80, 450);
        var head = s.rect(200, head_point + begin_point, 20, 20, 5).attr(
            {
                fill: "#eb4034",
                stroke: "#000",
                strokeWidth: 5
            });
        var body = s.rect(200, head_point + begin_point + 20, 20, e.detail.length_xiang, 5).attr(
            {
                fill: "#ebc034",
                stroke: "#000",
                strokeWidth: 5
            });

    }
  )

var default_length = 400;
var begin_point = 40;

var s = Snap('#xiang');
// console.log("xiang" + JSON.stringify(document.getElementById('xiang')));
// var s = Snap(document.getElementsByTagName('svg')[0]);
var head = s.rect(200, begin_point, 20, 20, 5).attr(
    {
        fill: "#eb4034",
        stroke: "#000",
        strokeWidth: 5
    });
var body = s.rect(200, begin_point + 20, 20, default_length, 5).attr(
    {
        fill: "#ebc034",
        stroke: "#000",
        strokeWidth: 5
    });

