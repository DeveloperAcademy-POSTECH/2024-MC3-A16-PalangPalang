//
//  AlarmOnSettings.swift
//  PalangPalang
//
//  Created by 박혜운 on 8/1/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

struct AlarmOnSettings: View {
  @Bindable var alarmViewModel: AlarmSettingsViewModel
  
  var body: some View {
    VStack {
      Spacer()
      
      ampmPicker(alarmViewModel: alarmViewModel)
        .padding(.bottom, 20)
      
      ClockSetting(alarm: .init(
        get: {alarmViewModel.state.alarm},
        set: { alarmViewModel.effect(action: .changeAlarm($0)) }
      )
      )
      .frame(height: 280)
      
      Button(
        action: {
          alarmViewModel.effect(action: .tappedSettingsDoneButton)
        },
        label: {
          Text("완료")
            .palangFont(.textBody01Bold)
            .foregroundColor(.palangWhite)
        }
      ).frame(maxWidth: .infinity, maxHeight: 60)
        .background(.palangGray)
        .cornerRadius(16)
        .padding(.horizontal, 131)
        .padding(.bottom, 145)
        .padding(.top, 90)
      
    }
    .frame(maxHeight: .infinity)
    .background(.palangYellow01)
    .ignoresSafeArea()
  }
}

#Preview {
  AlarmOnSettings(alarmViewModel: .init(useCase: AlarmUseCase.init()))
}

private struct CustomPickerView: UIViewRepresentable {
  var data: [[String]]
  @Binding var selection: String
  
  //UIView 그려주기
  func makeUIView(context: Context) -> UIPickerView {
    let picker = UIPickerView(frame: .zero)
    
    //뷰가 고유 크기보다 커지는 것을 방지하는 우선 순위를 설정
    picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    picker.dataSource = context.coordinator
    picker.delegate = context.coordinator
    return picker
  }
  
  //뷰 업데이트
  func updateUIView(_ uiView: UIPickerView, context: Context) {
    //selection 초기 값 설정
    if let selectedIndex = data[0].firstIndex(of: selection) {
      uiView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
    uiView.reloadAllComponents()
  }
  
  func makeCoordinator() -> CustomPickerView.Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: CustomPickerView
    
    init(_ CustomPickerView: CustomPickerView) {
      self.parent = CustomPickerView
    }
    
    //몇개의 pickerComponent가 있는지 data 배열에서 개수 받아오기
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1 // 각 CustomPickerView에 대해 한 개의 컴포넌트만 필요
    }
    
    //각 컴포넌트안에 담긴 row데이터 개수 받아오기
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return self.parent.data[0].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 80))
      let rowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
      
      rowLabel.text = self.parent.data[0][row]
      rowLabel.textAlignment = .center
      
      //selections영역 색 없애기
      pickerView.subviews[1].alpha = 0
      
      //selection된 font weight 변경
      if rowLabel.text == self.parent.selection{
        rowLabel.font = .palangFont(.numH1Bold)
        rowLabel.textColor = UIColor(hexCode: "2E2D2C")
      } else {
        rowLabel.font = .palangFont(.numH1)
        rowLabel.textColor = UIColor(hexCode: "2E2D2C")
      }
      
      view.addSubview(rowLabel)
      return view
    }
    
    //행(row값) 높이 설정하기
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      self.parent.selection = self.parent.data[0][row]
    }
  }
}

private struct ClockSetting: View {
  @Binding var alarm: AlarmSettingsModel
  
  var body: some View {
    HStack {
      
      CustomPickerView(data: [ValidHour.availableHours], selection: $alarm.set12Hour)
        .frame(width: 130)
      
      Text(":")
        .palangFont(.numSymbol01)
        .fontWeight(.bold)
        .padding(.bottom)
      
      CustomPickerView(data: [ValidMinutesOrSecond.availableMinutesOrSecond], selection: $alarm.minutes)
        .frame(width: 130)
    }
  }
}

private struct ampmPicker: View {
  @Bindable var alarmViewModel: AlarmSettingsViewModel
  
  var body: some View {
    HStack(spacing: 0) {
      Button(action: {
        alarmViewModel.effect(action: .tappedAmButton)
      }, label: {
        Text("AM")
          .palangFont(.textBody01Bold)
          .foregroundColor(alarmViewModel.state.isAmTapped ? .palangGray : .palangText02)
      })
      .padding(.trailing,20)
      
      Button(action: {
        alarmViewModel.effect(action: .tappedPmButton)
      }, label: {
        Text("PM")
          .palangFont(.textBody01Bold)
          .foregroundColor(alarmViewModel.state.isAmTapped ? .palangText02 : .palangGray)
      })
    }
  }
}
