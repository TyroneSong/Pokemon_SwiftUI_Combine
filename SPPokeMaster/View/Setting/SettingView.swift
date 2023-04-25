//
//  SettingView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/13.
//

import SwiftUI


struct SettingView: View {
    
    @EnvironmentObject var store: Store
    
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }
    
    var settings: AppState.Settings {
        store.appState.settings
    }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text(error.localizedDescripition))
        }
    }
    
    var accountSection: some View {
        Section(header: Text("账户")) {
            if settings.loginUser == nil {
                // 1. Picker
                Picker(selection: settingsBinding.checker.accountBehavior) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TextField("电子邮箱", text: settingsBinding.checker.email)
                    .foregroundColor(settings.isEmailValid ? .green : .red)
                
                SecureField("密码", text: settingsBinding.checker.password)
                
                if settings.checker.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.checker.verifyPasword)
                }
                if settings.loginRequesting {
                    SPActivityIndicatorView()
                } else {
                    Button(settings.checker.accountBehavior.text) {
                        switch settings.checker.accountBehavior {
                        case .register:
                            // 1. 验证密码
                            // 2. 注册
                            store.dispatch(.register(email: settings.checker.email, password: settings.checker.password, verifyWord: settings.checker.verifyPasword))
                        case .login:
                            self.store.dispatch(
                                .login(
                                    email: self.settings.checker.email,
                                    password: self.settings.checker.password
                                )
                            )
                        }
                    }
                }
                
            } else {
                Text(settings.loginUser!.email)
                Button("注销") {
                    store.dispatch(.logout)
                }
            }
        }
    }
    
    var optionSection: some View {
        
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: settingsBinding.sorting) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            } label: {
                Text("排序方式")
            }

            Toggle(isOn: settingsBinding.showFavoriteOnly) {
                Text("只显示收藏")
            }
            
            

        }
    }
    var actionSection: some View {
        Section() {
            Button {
                store.dispatch(.clearCache)
            } label: {
                Text("清空缓存")
                    .foregroundColor(.red)
            }

        }
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingView().environmentObject(Store())
    }
}
