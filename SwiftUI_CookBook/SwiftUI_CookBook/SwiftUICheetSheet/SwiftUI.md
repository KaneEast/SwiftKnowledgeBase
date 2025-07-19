#  SwiftUI

# 1. Layout & Containers
— Compose and position child views
• Stacks
  - VStack
  - HStack
  - ZStack (depth)
  - LazyVStack / LazyHStack
• Grids
  - LazyVGrid / LazyHGrid
  - Grid (iOS 16+)
• Scrollable
  - ScrollView
  - ScrollViewReader
• Adaptive
  - GeometryReader
  - ViewThatFits
  - ContainerRelativeFrame
• Form-like grouping
  - Form
  - List
  - Table (macOS)
  - ControlGroup
  - GroupBox
  - DisclosureGroup

# 2. Navigation & Structure
— Moving between screens or panes
• NavigationStack / NavigationLink
• NavigationSplitView
• TabView (incl. paging style)

# 3. Text & Data Entry
— Displaying text and capturing free-form input
• Read-only
  - Text
  - Label
  - LabeledContent (iOS 16+)
• Single-line input
  - TextField
  - SecureField
• Multi-line input
  - TextEditor

# 4. Selection Controls & Pickers
— Discrete choices; menus
• Picker (incl. segmented, wheel, menu styles)
• DatePicker / MultiDatePicker
• ColorPicker
• PhotosPicker
• Menu / ContextMenu
• Segmented Control (Picker)

# 5. Buttons & Actions
— Tappable controls
• Button / RenameButton
• Link / ShareLink
• SignInWithAppleButton
• Stepper
• Slider
• Toggle
• ProgressView / Gauge / Chart

# 6. Data Presentation & Feedback
— Showing status, progress, charts
• ProgressView
• Gauge
• Chart
• OutlineGroup
• ContentUnavailableView

# 7. Graphics, Images & Shapes
— Drawing, masking, painting
• Image / ImagePaint
• Canvas
• Paths & Shapes
  - Rectangle, RoundedRectangle, Circle, Capsule, Ellipse, Inset, Path
• Colors & Gradients
  - Color
  - LinearGradient, RadialGradient, AngularGradient, EllipticalGradient, ConicGradient, MeshGradient

# 8. Modifiers
— Attach behavior, effects, layout rules

## 8.1 Layout Modifiers / Modals
  - frame(width:/height:), padding(), offset(), position(), background(), overlay()
  - ignoresSafeArea(), fixedSize(), aspectRatio(), layoutPriority(), zIndex()
  - coordinateSpace(), alignmentGuide(), fullScreenCover(), sheet(), popover(), toolbar()

## 8.2 Visual & Effect Modifiers
  - foregroundColor(), foregroundStyle(), accentColor()
  - shadow(), blur(), brightness(), contrast(), saturation(), hueRotation()
  - blendMode(), compositingGroup(), mask(), clipShape(), clipping(), redacted()

## 8.3 Interaction Modifiers
  - onTapGesture(), onLongPressGesture(), gesture(Drag/Magnify/Rotate)
  - allowsHitTesting(), disabled(), statusBarHidden(), searchable()

## 8.4 Presentation Modifiers
  - alert(), confirmationDialog(), actionSheet()

# 9. Styling Protocols
— Customize default look & feel
• ButtonStyle
• ToggleStyle
• ProgressViewStyle
• DatePickerStyle / GroupBoxStyle / LabelStyle / MenuStyle

# 10. Accessibility & Environment
— VoiceOver, Dynamic Type, Localization
• accessibilityLabel(), accessibilityHint(), etc.
• environment(\.locale), environment(\.sizeCategory)

# 11. Imported Framework Integrations
— Views from other SDKs
• AVKit (VideoPlayer)
• MapKit (Map)
• StoreKit (ProductView, etc.)





https://swiftuirecipes.com/blog/swift-5-5-async-await-cheatsheet
https://swiftuirecipes.com/blog/play-video-in-swiftui
https://swiftuirecipes.com/blog/how-to-hide-a-swiftui-view-visible-invisible-gone
https://swiftuirecipes.com/blog/swiftui-play-youtube-video
https://swiftuirecipes.com/blog/swiftui-haptic-feedback
