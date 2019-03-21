import CsrfToken from "./csrf_token"

export default class UploadService {
  constructor(url) {
    this.url = url

    this.cancel_flag = false
  }

  cancel = () => {
    this.cancel_flag = true
  }

  run = (files, callbacks) => {
    if (files === undefined || files.length === 0) {
      return false
    }
    const { ondoneall, ondonesingle, onprogressall, onprogresssingle, onerror, oncancel } = callbacks;
    let pending_files = []
    let total_files_size = 0
    for (let i = 0; i < files.length; ++i) {
      pending_files.push({ file: files[i], uuid: this.uuid() })
      total_files_size += files[i].size
    }

    var uploaded_bytes = 0
    let run = (current_file_index) => {
      if (current_file_index >= pending_files.length) {
        ondoneall();
        return;
      }
      this.upload_single(pending_files[current_file_index].file, pending_files[current_file_index].uuid,
                         (file, uuid)=> {
                           if(this.iscancelled()) {
                             oncancel()
                             this.reset_cancelled()
                           } else {
                             ondonesingle(file, uuid)
                             run(current_file_index + 1)
                           }
                         },
                         (err, file, uuid)=> {
                           onerror(err, file, uuid);
                         },
                         (file, uuid, offset, length, file_size)=> {
                           uploaded_bytes += length
                           onprogresssingle(file, uuid, offset, file_size)
                           onprogressall(uploaded_bytes, total_files_size)
                         });
    };
    run(0)
    return true
  }

  upload_single = (file, uuid, onfinish, onerror, onprogress) => {
    let file_size = file.size
    let chunk_size = 3 * 1024 * 1024 // bytes
    var offset = 0

    let chunk_reader_block = (_offset, length, _file) => {
      var r = new FileReader()
      var blob = _file.slice(_offset, length + _offset)
      r.onload = read_event_handler
      r.readAsArrayBuffer(blob)
    }
    let read_event_handler = (evt) => {
      if (evt.target.error == null) {
        this.upload_chunk(new Uint8Array(evt.target.result), uuid, offset, file_size,
          ()=> {
            onprogress(file, uuid, offset, evt.loaded, file_size)
            if (offset >= file_size || this.iscancelled()) {
                onfinish(file, uuid)
                return true
            }
            chunk_reader_block(offset, chunk_size, file); // of to the next chunk
          },
          (message)=> {
            onerror(message, file, uuid);
            return false
          });
        offset += evt.loaded
      } else {
          onerror(evt.target.error, file, uuid)
          return false
      }
    };
    chunk_reader_block(offset, chunk_size, file) // now let's start the read with the first block
  }

  upload_chunk = (data, uuid, offset, total, onsuccess, onerror) => {
    let headers = new Headers()
    headers.append('Content-Type', 'application/octet-stream')
    headers.append('X-Upload-Uuid', uuid)
    headers.append('Content-Range', `bytes ${offset}-${offset + data.length}/${total}`)
    headers.append('Content-Transfer-Encoding', 'binary')
    headers.append('X-CSRF-Token', CsrfToken.get())

    let ok = false
    fetch(this.url, { method: 'POST', headers: headers, body: data })
    .then(response => {
      ok = response.ok
      return response.json()
    })
    .then(json => {
      if (ok) {
        onsuccess()
      } else {
        onerror(json.error)
      }
    })
    .catch((e) => onerror(e))
  }

  iscancelled = () => {
    return this.cancel_flag === true
  }

  reset_cancelled = () => {
    this.cancel_flag = false
  }

  uuid = () => {
    const s4 = () => Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()
  }
}
