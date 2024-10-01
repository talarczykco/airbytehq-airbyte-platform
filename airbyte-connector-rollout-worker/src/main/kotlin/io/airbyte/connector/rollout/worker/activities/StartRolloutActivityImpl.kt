/*
 * Copyright (c) 2020-2024 Airbyte, Inc., all rights reserved.
 */

package io.airbyte.connector.rollout.worker.activities

import io.airbyte.api.client.AirbyteApiClient
import io.airbyte.api.client.generated.ConnectorRolloutApi
import io.airbyte.api.client.model.generated.ConnectorRolloutStartRequestBody
import io.airbyte.api.client.model.generated.ConnectorRolloutStartResponse
import io.airbyte.api.client.model.generated.ConnectorRolloutStrategy
import io.airbyte.connector.rollout.shared.ConnectorRolloutActivityHelpers
import io.airbyte.connector.rollout.shared.models.ConnectorRolloutActivityInputStart
import io.airbyte.connector.rollout.shared.models.ConnectorRolloutOutput
import io.temporal.activity.Activity
import jakarta.inject.Singleton
import org.openapitools.client.infrastructure.ClientException
import org.slf4j.LoggerFactory
import java.io.IOException

@Singleton
class StartRolloutActivityImpl(private val airbyteApiClient: AirbyteApiClient) : StartRolloutActivity {
  private val log = LoggerFactory.getLogger(StartRolloutActivityImpl::class.java)

  init {
    log.info("Initialized StartRolloutActivityImpl")
  }

  override fun startRollout(
    workflowRunId: String,
    input: ConnectorRolloutActivityInputStart,
  ): ConnectorRolloutOutput {
    log.info("Activity startRollout Initializing rollout for ${input.dockerRepository}:${input.dockerImageTag}")

    val client: ConnectorRolloutApi = airbyteApiClient.connectorRolloutApi
    val body =
      ConnectorRolloutStartRequestBody(
        input.rolloutId,
        workflowRunId,
        ConnectorRolloutStrategy.MANUAL,
        input.updatedBy,
      )

    return try {
      log.info("Activity startRollout starting for ${input.dockerRepository}:${input.dockerImageTag}; baseUrl=${client.baseUrl}")
      val response: ConnectorRolloutStartResponse = client.startConnectorRollout(body)

      log.info("Activity startRollout ConnectorRolloutStartResponse=${response.data}")

      ConnectorRolloutActivityHelpers.mapToConnectorRollout(response.data)
    } catch (e: IOException) {
      throw Activity.wrap(e)
    } catch (e: ClientException) {
      throw Activity.wrap(e)
    }
  }
}
