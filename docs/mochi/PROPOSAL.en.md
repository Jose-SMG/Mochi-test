# Mochi Studio — contribution proposal

Mochi Studio makes Coucou more personal: a room to decorate, a look to keep and a companion that can hold onto native window edges. It is integrated with Coucou’s official 0.6 main work, preserving the original session launcher and agent workflows.

## The experience

- Open a separate, resizable studio. Choose Cozy, Gamer, Minimalist or Mediterranean and arrange furniture, lighting and camera position. Save named rooms.
- Combine an outfit, glasses, a scarf and a body appearance. Diamond Mochi keeps the rounded black body and wears many small bright stones. Save named looks.
- Drag Mochi to an exposed window top edge and release. His arms grip automatically, he follows the window and can jump to another valid edge. No Alt/Option gesture is required.
- Export a transparent 1600 × 1600 PNG, or bring a cup, cushion or plant onto the desktop.

## Review in two parts

1. **Personal room and wardrobe:** the shared renderer, cosmetic preferences, editor, photos and props. The room is opened explicitly and does not receive agent prompts, keys or integration data.
2. **Native attachment and jumps:** stacked on the room contribution, connecting the shared appearance to AppKit/Win32 tracking and safe edge selection.

The integration beta includes both. Publishing/signing/version metadata are kept on its own branch, outside the proposed feature changes. The exact review branches, patches and build results are in the review report.

## The main tradeoff

The studio uses a bundled, offline Three.js renderer with its MIT notice. This gives WebKit and WebView2 the same room, materials, wardrobe and PNG export. It adds a dependency and Windows webviews; those costs need Louis’s review. The renderer loads on demand, caps animation work and pauses when hidden. Canvas fallbacks remain available. Measured CPU and memory data describe the actual CI machine and workload, not a promise for every device.

## Feedback requested

Does this fit Coucou’s visual direction? Is the shared 3D dependency acceptable? Would you prefer the room and native attachment to remain optional experiments? We can adjust the scope before proposing a merge.

The attached demo uses the real shared interface with its development bridge for the editor, and separately identified native Windows evidence. Original app, character, icon and sound credits remain with Louis Raillé. This is a community contribution, not a claim of an official release or endorsement.
