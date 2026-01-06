#!/bin/bash

echo " Opening Xcode Workspace..."
open ios/Runner.xcworkspace

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "  iOS CODE SIGNING REQUIRED"
echo "════════════════════════════════════════════════════════════════════"
echo "1. Xcode has been opened for you."
echo "2. In Xcode, click on the root 'Runner' icon in the left project navigator."
echo "3. Select the 'Runner' TARGET (not Project) in the main view."
echo "4. Click the 'Signing & Capabilities' tab at the top."
echo "5. Under 'Team', ensure your Apple ID is selected."
echo "   - If 'None', click 'Add an Account...' and log in."
echo ""
echo "NOTE: Do this for BOTH the 'Runner' target AND the 'BuckelWidget' target."
echo "════════════════════════════════════════════════════════════════════"
echo "Once done, return here and run 'flutter run' again."
