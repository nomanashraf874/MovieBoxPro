//
//  TrailerViewController.swift
//  MovieBoxPro
//
//  Created by Shaki Ch on 4/29/23.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKNavigationDelegate {

    private let webView = WKWebView()
    var movieId = ""
    var videoId:String = ""
    var movieApiManager = MovieApiManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(videoId)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        movieApiManager.getMovieID(id: movieId) { key in
            self.videoId = key
            self.loadPlayer()
        }
    }
    private func loadPlayer() {
        let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <script src="https://www.youtube.com/iframe_api"></script>
                <style>
                    body { margin: 0; padding: 0; }
                    iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
                </style>
                <script>
                    var meta = document.createElement('meta');
                    meta.setAttribute('name', 'viewport');
                    meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0');
                    document.getElementsByTagName('head')[0].appendChild(meta);
                </script>
            </head>
            <body>
                <div id="player"></div>
                <script>
                    var player;
                    function onYouTubeIframeAPIReady() {
                        player = new YT.Player('player', {
                            height: '100%',
                            width: '100%',
                            videoId: '\(videoId)',
                            playerVars: {
                                'controls': 1,
                                'autohide': 1,
                                'showinfo': 0,
                                'playsinline': 0,
                                'fs': 1
                            },
                            events: {
                                'onReady': onPlayerReady,
                                'onStateChange': onPlayerStateChange
                            }
                        });
                    }
                    function onPlayerReady(event) {
                        event.target.playVideo();
                    }
                    function onPlayerStateChange(event) {
                        if (event.data == YT.PlayerState.ENDED) {
                            event.target.stopVideo();
                        }
                    }
                </script>
            </body>
            </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("onYouTubeIframeAPIReady()") { (result, error) in
            if let error = error {
                print("Error initializing YouTube player: \(error.localizedDescription)")
            }
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
