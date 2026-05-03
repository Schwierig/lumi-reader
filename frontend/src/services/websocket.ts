import { createConsumer } from "@rails/actioncable"

const SAME_ORIGIN = import.meta.env.VITE_SAME_ORIGIN === "true"
const WS_URL = SAME_ORIGIN
    ? `${location.protocol === "https:" ? "wss:" : "ws:"}//${location.host}/cable`
    : (import.meta.env.VITE_WS_URL ?? (import.meta.env.PROD ? "wss://api.lumireader.app/cable" : "ws://localhost:3000/cable"))
export default createConsumer(WS_URL)
