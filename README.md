# TextCrunch
---

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gcoomber/TextCrunch?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Textcrunch is an iOS application(iOS7 or later) that makes buying and selling textbooks easy for students.

[Documentation Folder](https://drive.google.com/a/ualberta.ca/?tab=mo#folders/0B3Dml7eFPSQ-cnJ2TVFNdmhtU2s)

[Meeting Minutes ](https://docs.google.com/document/d/11F-L3x2ccZE2GWCgL6mIrnn2eDma-uQzakEOv66Hdhg/edit?usp=sharing)

[Interation Plan](https://docs.google.com/spreadsheets/d/1stDzi9Jg7wkI0EvA0Bl5i-6_2FDbe8f8oR2sb_0ZHO4/edit?usp=sharing)

[Requirements and Planning Document](https://docs.google.com/a/ualberta.ca/document/d/1bmjq_dkj4x_Q1tWqtzVzgbF_mbeWVTM-F2QmuKVp4K0/edit#heading=h.rf5nc6mi4le2)

[Release and Iteration Burndown Charts](https://docs.google.com/document/d/1kTm439JJk_D3D2b_TaEKMjeV1N-D-kJ1AzcBl5fU14I/edit?usp=sharing)

### Installation

#### CocoaPods

We use CocoaPods for dependency management. In order for you to install CocoaPods you will need a working version of
[Ruby](https://www.ruby-lang.org/en/documentation/installation/).

To install CocoaPods, assuming you're in the TextCrunch root:

```bash
sudo gem install cocoapods
pod setup
pod install
```
**Important:** Open the project using TextCrunch.xcworkspace via xCode otherwise you're going to run into issues.

If this all worked successfully, you'll have all of the latest dependecies installed and working properly!


#### Development

You can modify and run the app by cloning this repository and then opening the project within XCode(v6.1 required).

#### Text Crunch Cloud

A portion of our logic lives within Parse's Cloud Code environment. This is 100% javascript and is used for dealing with our payment system. You can find all related code in the `TxtCrunchCloud/` folder.

##### Cloud Code Deployment:
In order to deploy code to the cloud, you'll need to read [this](https://parse.com/docs/cloud_code_guide#clt) documentation and setup the Parse CLI tool.

### Third Party Resources
