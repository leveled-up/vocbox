# Useful Functions for VocBox Client Scripts

# HttpClient Class
# client = new HttpClient()
#client.get 'http://some/thing?with=arguments', (response) -> [...]

HttpClient = () ->
    this.get = (aUrl, aCallback) ->
        anHttpRequest = new XMLHttpRequest()
        anHttpRequest.onreadystatechange = () ->
            if anHttpRequest.readyState == 4 and anHttpRequest.status == 200
                aCallback anHttpRequest.responseText

        anHttpRequest.open "GET", aUrl, true
        anHttpRequest.send null
