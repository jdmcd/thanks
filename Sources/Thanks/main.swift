import Console
import Foundation

enum TerminalError: Error {
    case packageFileDoesNotExist
    case generalError
    case cannotCreateThanksFolder
    case cannotLoadAuthFile
}

var arguments = CommandLine.arguments

let terminal = Terminal(arguments: arguments)

var iterator = arguments.makeIterator()

guard let executable = iterator.next() else {
    throw ConsoleError.noExecutable
}

do {
    if terminal.arguments.contains("-h") || terminal.arguments.contains("--h") || terminal.arguments.contains("help") {
        let helpText = """
            Thanks is a small tool that allows you to
            say thanks (in the form of Github stars) to all
            of the repos that make your project possible.

            The tool will loop through all of the dependencies
            in `Package.resolved` and star them from your account.

            If you want to give a star to this package as well,
            add the `--self` flag.
        """
        terminal.print(helpText)
        exit(1)
    }
    
    let starSelf = terminal.arguments.contains("--self")
    
    //check if Package.resolved exists
    let oAuthToken = try Helpers.getOauthToken()
    
    if oAuthToken == "" {
        let askString = """
        Please create a GitHub OAuth token.
        Head to https://github.com/settings/tokens/new?scopes=repo&description=Swift+Thanks+token
        to retrieve a token. It will be stored for future use by Swift Thanks.
        """
        
        let enteredToken = terminal.ask(askString, style: .info, secure: true)
        
        let loadingBar = terminal.loadingBar(title: "Setting OAuth Token")
        loadingBar.start()
        try Helpers.setOAuthToken(token: enteredToken)
        
        loadingBar.finish()
    }

    guard let dataContents = FileManager().contents(atPath: "Package.resolved") else {
        throw TerminalError.packageFileDoesNotExist
    }

    let decoder = JSONDecoder()
    let resolvedPackage = try decoder.decode(ResolvedPackage.self, from: dataContents)

    for pin in resolvedPackage.object.pins {
        let loadingBar = terminal.loadingBar(title: "Thanking \(pin.package)")
        loadingBar.start()

        if try Helpers.star(terminal: terminal, repo: pin) {
            loadingBar.finish()
        } else {
            loadingBar.fail("Something went wrong")
        }
    }
    
    if starSelf {
        let loadingBar = terminal.loadingBar(title: "Thanking Swift Thanks")
        loadingBar.start()
        
        let pin = ResolvedPackage.Pin(package: "Swift Thanks", repositoryURL: "https://github.com/mcdappdev/thanks.git")
        
        if try Helpers.star(terminal: terminal, repo: pin) {
            loadingBar.finish()
        } else {
            loadingBar.fail("Something went wrong")
        }
    }
} catch {
    terminal.error("Error: ", newLine: false)
    terminal.print("\(error)")
    exit(1)
}
