let err = (error as? URLError)?.code
var errorMessage = ""
//        if err == .timedOut {
//            errorMessage = "ma laaaa"
//        } else if err == .notConnectedToInternet {
//            errorMessage = "no internet i sas"
//        } else {
//            errorMessage = "Sorry, Something went wrong"
//        }
switch err {
case URLError.timedOut: errorMessage = K.timeOutMessage
case URLError.notConnectedToInternet: errorMessage = K.noConnection
default: errorMessage = K.errorFetchData
}
DispatchQueue.main.async {
    self.noInternet.isHidden = false
    self.noInternet.text = errorMessage
}
