/**
 * Copyright (c) 2019, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.media;

import android.media.TranscodingJobParcel;
import android.media.TranscodingRequestParcel;
import android.media.ITranscodingServiceClient;

/**
 * Binder interface for MediaTranscodingService.
 *
 * {@hide}
 */
interface IMediaTranscodingService {
    /**
     * All MediaTranscoding service and device Binder calls may return a
     * ServiceSpecificException with the following error codes
     */
    const int ERROR_PERMISSION_DENIED = 1;
    const int ERROR_ALREADY_EXISTS = 2;
    const int ERROR_ILLEGAL_ARGUMENT = 3;
    const int ERROR_DISCONNECTED = 4;
    const int ERROR_TIMED_OUT = 5;
    const int ERROR_DISABLED = 6;
    const int ERROR_INVALID_OPERATION = 7;

    /**
     * Default UID/PID values for non-privileged callers of
     * registerClient().
     */
    const int USE_CALLING_UID = -1;
    const int USE_CALLING_PID = -1;

    /**
     * Register the client with the MediaTranscodingService.
     *
     * Client must call this function to register itself with the service in order to perform
     * transcoding. This function will return a unique positive Id assigned by the service.
     * Client should save this Id and use it for all the transaction with the service.
     *
     * @param client interface for the MediaTranscodingService to call the client.
     * @param opPackageName op package name of the client.
     * @param clientUid user id of the client.
     * @param clientPid process id of the client.
     * @return a unique positive Id assigned to the client by the service, -1  means failed to
     * register.
     */
    int registerClient(in ITranscodingServiceClient client,
                       in String opPackageName,
                       in int clientUid,
                       in int clientPid);

    /**
    * Unregister the client with the MediaTranscodingService.
    *
    * Client will not be able to perform any more transcoding after unregister.
    *
    * @param clientId assigned Id of the client.
    * @return true if succeeds, false otherwise.
    */
    boolean unregisterClient(in int clientId);

    /**
     * Submits a transcoding request to MediaTranscodingService.
     *
     * @param clientId assigned Id of the client.
     * @param request a TranscodingRequest contains transcoding configuration.
     * @param job(output variable) a TranscodingJob generated by the MediaTranscodingService.
     * @return a unique positive jobId generated by the MediaTranscodingService, -1 means failure.
     */
    int submitRequest(in int clientId,
                      in TranscodingRequestParcel request,
                      out TranscodingJobParcel job);

    /**
     * Cancels a transcoding job.
     *
     * @param clientId assigned id of the client.
     * @param jobId a TranscodingJob generated by the MediaTranscodingService.
     * @return true if succeeds, false otherwise.
     */
    boolean cancelJob(in int clientId, in int jobId);

    /**
     * Queries the job detail associated with a jobId.
     *
     * @param jobId a TranscodingJob generated by the MediaTranscodingService.
     * @param job(output variable) the TranscodingJob associated with the jobId.
     * @return true if succeeds, false otherwise.
     */
    boolean getJobWithId(in int jobId, out TranscodingJobParcel job);
}
