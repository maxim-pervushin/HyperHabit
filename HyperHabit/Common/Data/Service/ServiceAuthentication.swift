//
// Created by Maxim Pervushin on 07/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol ServiceAuthentication {

    func signUpWithUsername(username: String, password: String, block: (Bool, NSError?) -> Void)

    func logInWithUsername(username: String, password: String, block: (Bool, NSError?) -> Void)

    func logOut(block: (Bool, NSError?) -> Void)

    func resetPasswordWithUsername(username: String, block: (Bool, NSError?) -> Void)
}